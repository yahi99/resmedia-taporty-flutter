import 'dart:async';
import 'dart:core';

import 'package:dash/dash.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/CartBloc.dart';
import 'package:resmedia_taporty_customer/blocs/LocationBloc.dart';
import 'package:resmedia_taporty_customer/blocs/StripeBloc.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:random_string/random_string.dart';

class CheckoutBloc extends Bloc {
  final DatabaseService _db = DatabaseService();
  final FunctionService _functions = FunctionService();
  final userBloc = $Provider.of<UserBloc>();
  final cartBloc = $Provider.of<CartBloc>();
  final supplierBloc = $Provider.of<SupplierBloc>();
  final locationBloc = $Provider.of<LocationBloc>();
  final stripeBloc = $Provider.of<StripeBloc>();

  // Controller per la CartPage
  TextEditingController noteController;

  // Controller per la ShippingPage
  BehaviorSubject<DateTime> _selectedDateController;
  Stream<DateTime> get outSelectedDate => _selectedDateController.stream;

  // Mostra solamente il range di date in cui sono presenti turni disponibili
  BehaviorSubject<List<DateTime>> _availableDateRangeController;
  Stream<List<DateTime>> get outAvailableDateRange => _availableDateRangeController.stream;

  BehaviorSubject<List<ShiftModel>> _shiftListController;

  // Mostra solamente i turni inclusi nella giornata selezionata.
  Stream<List<ShiftModel>> get outAvailableShifts => CombineLatestStream.combine2(_shiftListController.stream, _selectedDateController.stream, (shifts, selectedDate) {
        if (shifts == null || selectedDate == null) return null;
        return shifts
            .where(
              (s) =>
                  (s.startTime.isAtSameMomentAs(selectedDate) || s.startTime.isAfter(selectedDate)) &&
                  s.startTime.isBefore(
                    selectedDate.add(Duration(days: 1)),
                  ),
            )
            .toList();
      });

  StreamSubscription _availableShiftSub;

  BehaviorSubject<ShiftModel> _selectedShiftController;
  ShiftModel get selectedShift => _selectedShiftController.value;
  Stream<ShiftModel> get outSelectedShift => _selectedShiftController.stream;

  BehaviorSubject<bool> _confirmLoadingController;
  Stream<bool> get outConfirmLoading => _confirmLoadingController.stream;

  TextEditingController nameController;
  TextEditingController phoneController;

  @override
  void dispose() {
    noteController.dispose();
    nameController.dispose();
    phoneController.dispose();
    _selectedShiftController.close();
    _selectedDateController.close();
    _shiftListController.close();
    _availableShiftSub.cancel();
    _confirmLoadingController.close();
    _availableDateRangeController.close();
  }

  CheckoutBloc.instance() {
    noteController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    _confirmLoadingController = BehaviorSubject.seeded(false);
    _selectedDateController = BehaviorSubject.seeded(DateTimeHelper.getDay(DateTime.now()));
    _selectedShiftController = BehaviorSubject.seeded(null);
    _shiftListController = BehaviorSubject.seeded(null);
    _availableDateRangeController = BehaviorSubject.seeded(null);

    _availableShiftSub = supplierBloc.outSupplierId.listen((supplierId) => updateAvailableShifts());
  }

  Future updateAvailableShifts() async {
    _shiftListController.value = null;
    _selectedShiftController.value = null;
    _availableDateRangeController.value = null;
    _selectedDateController.value = null;

    SupplierModel supplier = await supplierBloc.outSupplier.first;

    if (supplier == null) return;
    var shifts = _shiftListController.value = await _getAvailableShifts(supplier);

    List<DateTime> range = new List<DateTime>();
    if (shifts.isNotEmpty) {
      range.add(DateTimeHelper.getDay(shifts.first.startTime));
      range.add(DateTimeHelper.getDay(shifts.last.startTime));
      _selectedDateController.value = range[0];
    }
    _availableDateRangeController.value = range;
  }

  Future<List<ShiftModel>> _getAvailableShifts(SupplierModel supplier) async {
    DateTime now = DateTime.now();
    // Orari di inizio turno nel range di 2 giorni
    var startTimes = supplier.getShiftStartTimes(now, now.add(Duration(days: 2)));
    var filteredShifts = List<ShiftModel>();

    /* 
      Non è possibile richiedere un orario di consegna entro la prossima ora o oltre le 47 ore 
      (per evitare il caso il cliente stia nel checkout per molto tempo)
    */
    startTimes = startTimes.where((startTime) {
      var diff = startTime.difference(DateTime.now());
      return diff.inMinutes >= 60 && diff.inHours <= 47;
    }).toList();

    // Ordina i turni
    startTimes.sort();

    for (var startTime in startTimes) {
      var reservedShifts = await _db.getAvailableShifts(datetimeToTimestamp(startTime), supplier.geohashPoint.geopoint);

      // Aggiunge uno dei turni alla lista di turni selezionabili dall'utente (in questo caso il primo, tanto è indifferente)
      if (reservedShifts.length > 0) {
        filteredShifts.add(reservedShifts[0]);
      }
    }

    return filteredShifts;
  }

  void setDefaultValues() {
    var user = userBloc.user;
    assert(user != null);

    noteController.text = "";
    _selectedDateController.value = DateTimeHelper.getDay(DateTime.now());
    _selectedShiftController.value = null;
    _availableDateRangeController.value = null;
    if (user.nominative != null) nameController.text = user.nominative;
    if (user.phoneNumber != null) phoneController.text = user.phoneNumber;
  }

  void changeSelectedDate(DateTime date) {
    _selectedDateController.value = date;
    _selectedShiftController.value = null;
  }

  void changeSelectedShift(ShiftModel shift) {
    _selectedShiftController.value = shift;
  }

  Future<bool> processOrder() async {
    _confirmLoadingController.value = true;
    try {
      // Cerca un potenziale fattorino per l'ordine
      var driverId = await _findDriver();

      // Assegna un id a 10 cifre all'ordine
      var orderId = randomNumeric(10);

      // Ottiene la lista di OrderProductModel
      var products = _getOrderProducts();

      // Calcola il totale dei prodotti
      var cartAmount = products.fold(0, (price, product) => price + product.quantity * product.price);

      // Ottiene il prezzo per la spedizione, la percentuale del fornitore e il compenso del fattorino
      var settings = await _db.getSettingsStream().first;
      var deliveryAmount = settings.deliveryAmount;
      var supplierPercentage = settings.supplierPercentage;
      var driverAmount = settings.driverAmount;

      // Crea il PaymentIntent
      var paymentIntentId = await _processPayment(orderId, cartAmount, deliveryAmount);

      // Conferma l'ordine e lo salva nel database
      await _confirmOrder(driverId, paymentIntentId, orderId, cartAmount, deliveryAmount, supplierPercentage, driverAmount, products);
      _confirmLoadingController.value = false;
    } catch (err) {
      _confirmLoadingController.value = false;
      throw err;
    }

    return true;
  }

  Future<String> _findDriver() async {
    var supplierId = supplierBloc.supplierId;
    var supplier = supplierBloc.supplier;

    var driverId = await _db.chooseDriver(datetimeToTimestamp(selectedShift.startTime), supplierId, supplier.geohashPoint.geopoint);
    if (driverId == null) throw new NoAvailableDriverException("No available drivers found.");
    return driverId;
  }

  List<OrderProductModel> _getOrderProducts() {
    var cartProducts = cartBloc.cart.products;
    var products = supplierBloc.products;
    var orderProducts = List<OrderProductModel>();
    for (var cartProduct in cartProducts) {
      if (cartProduct.quantity <= 0) continue;
      var product = products.firstWhere((p) => p.id == cartProduct.id, orElse: () => null);
      if (product != null) {
        orderProducts.add(OrderProductModel(id: product.id, imageUrl: product.imageUrl, quantity: cartProduct.quantity, name: product.name, price: product.price, notes: cartProduct.notes));
      }
    }
    return orderProducts;
  }

  Future<String> _processPayment(String orderId, double cartAmount, double deliveryAmount) async {
    var result = await _functions.createPaymentIntent(stripeBloc.paymentMethod.id, cartAmount + deliveryAmount, orderId);
    var confirmPaymentResult;
    try {
      confirmPaymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: result.clientSecret,
        paymentMethodId: stripeBloc.paymentMethod.id,
      ));
    } catch (err) {
      throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    }
    if (confirmPaymentResult.status != 'requires_capture') throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    return confirmPaymentResult.paymentIntentId;
  }

  Future<bool> _confirmOrder(
      String driverId, String paymentIntentId, String orderId, double cartAmount, double deliveryAmount, double supplierPercentage, double driverAmount, List<OrderProductModel> products) async {
    assert(selectedShift != null);
    assert(stripeBloc.paymentMethod != null);

    var customer = userBloc.user;
    var location = locationBloc.customerLocation;
    var supplier = supplierBloc.supplier;
    var driver = await _db.getDriverById(driverId);

    var order = OrderModel(
      customerId: customer.id,
      driverId: driverId,
      supplierId: supplier.id,
      notes: noteController.text,
      shiftStartTime: selectedShift.startTime,
      preferredDeliveryTimestamp: selectedShift.endTime,
      productCount: products.fold(0, (count, product) => count + product.quantity),
      cartAmount: cartAmount,
      deliveryAmount: deliveryAmount,
      supplierPercentage: supplierPercentage,
      driverAmount: driverAmount,
      state: OrderState.NEW,
      customerImageUrl: customer.imageUrl,
      customerName: nameController.text,
      customerCoordinates: location.coordinates,
      customerAddress: location.address,
      customerPhoneNumber: phoneController.text,
      driverImageUrl: driver.imageUrl,
      driverName: driver.nominative,
      driverPhoneNumber: driver.phoneNumber,
      supplierImageUrl: supplier.imageUrl,
      supplierName: supplier.name,
      supplierCoordinates: supplier.geohashPoint.geopoint,
      supplierAddress: supplier.address,
      supplierPhoneNumber: supplier.phoneNumber,
      paymentIntentId: paymentIntentId,
      creationTimestamp: DateTime.now(),
      products: products,
    );

    await _db.createOrder(
      orderId,
      order,
    );

    reset();
    return true;
  }

  void reset() {
    noteController.clear();
    nameController.clear();
    phoneController.clear();
    cartBloc.clearCart();
  }
}
