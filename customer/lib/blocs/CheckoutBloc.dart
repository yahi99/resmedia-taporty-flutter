import 'dart:async';
import 'dart:core';

import 'package:cloud_functions/cloud_functions.dart';
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
import 'package:tuple/tuple.dart';

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
  DateTime get _selectedDate => _selectedDateController.value;

  BehaviorSubject<List<ShiftModel>> _availableShiftListController;
  Stream<List<ShiftModel>> get outAvailableShifts => _availableShiftListController.stream;
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
    _availableShiftListController.close();
    _availableShiftSub.cancel();
    _confirmLoadingController.close();
  }

  CheckoutBloc.instance() {
    noteController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    _confirmLoadingController = BehaviorSubject.seeded(false);
    _selectedDateController = BehaviorSubject.seeded(DateTimeHelper.getDay(DateTime.now()));
    _selectedShiftController = BehaviorSubject.seeded(null);

    // Aggiorna i turni disponibili ogni volta che l'utente seleziona un nuovo giorno di consegna o un nuovo ristorante
    _availableShiftSub = CombineLatestStream.combine2(_selectedDateController.stream, supplierBloc.outSupplierId, (DateTime _selectedDate, String _supplierId) => Tuple2(_selectedDate, _supplierId))
        .listen((tuple) async {
      // Reimposta i turni disponibili e il turno selezionato a null
      _availableShiftListController.value = null;
      _selectedShiftController.value = null;
      if (tuple.item1 == null || tuple.item2 == null) return;

      // Imposta i turni disponibili
      var shifts = _availableShiftListController.value = await _getAvailableShifts(tuple.item1, tuple.item2);
      _selectedShiftController.value = (shifts.isNotEmpty ? shifts.first : null);
    });
  }

  Future<List<ShiftModel>> _getAvailableShifts(DateTime selectedDate, String supplierId) async {
    var supplier = await supplierBloc.outSupplier.first;
    /* 
      Non è possibile richiedere un orario di consegna entro la prossima ora o oltre le 47 ore 
      (per evitare il caso il cliente stia nel checkout per molto tempo)
    */
    var shiftStartTime = DateTime.now().add(Duration(hours: 1));
    var shiftEndTime = DateTime.now().add(Duration(hours: 24));
    List<ShiftModel> availableShifts = await _db.getAvailableShifts(
      selectedDate,
      supplier.areaId,
      datetimeToTimestamp(shiftStartTime),
      datetimeToTimestamp(shiftEndTime),
    );

    // Mostra solamente i turni in linea con l'orario del ristorante
    var startTimes = supplier.getShiftStartTimes(selectedDate);
    return availableShifts.where((shift) => startTimes.contains(shift.startTime)).toList();
  }

  void setDefaultValues() {
    var user = userBloc.user;
    assert(user != null);

    noteController.text = "";
    _selectedDateController.value = DateTimeHelper.getDay(DateTime.now());
    _selectedShiftController.value = null;
    if (user.nominative != null) nameController.text = user.nominative;
    if (user.phoneNumber != null) phoneController.text = user.phoneNumber;
  }

  void changeSelectedDate(DateTime date) {
    _selectedDateController.value = date;
  }

  void changeSelectedShift(ShiftModel shift) {
    _selectedShiftController.value = shift;
  }

  Future<bool> processOrder() async {
    _confirmLoadingController.value = true;
    try {
      var paymentIntentId = await _processPayment();
      var driverId = await _findDriver();
      await _confirmOrder(driverId, paymentIntentId);
    } catch (err) {
      _confirmLoadingController.value = false;
      throw err;
    }

    return true;
  }

  Future<String> _processPayment() async {
    var result = await _functions.createPaymentIntent(stripeBloc.paymentMethod.id, cartBloc.cart.totalPrice);
    var confirmPaymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
      clientSecret: result.clientSecret,
      paymentMethodId: stripeBloc.paymentMethod.id,
    ));
    if (confirmPaymentResult.status != 'requires_capture') throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    return confirmPaymentResult.paymentIntentId;
  }

  Future<String> _findDriver() async {
    var supplier = await supplierBloc.outSupplier.first;
    var customerCoordinates = locationBloc.customerLocation.coordinates;
    var driverId = await _db.chooseDriver(supplier.areaId, _selectedDate, selectedShift.startTime, customerCoordinates, supplier.geohashPoint.geopoint);
    if (driverId == null) throw new NoAvailableDriverException("No available drivers found.");
    return driverId;
  }

  Future<bool> _confirmOrder(String driverId, String paymentIntentId) async {
    assert(selectedShift != null);
    assert(stripeBloc.paymentMethod != null);

    var products = cartBloc.clearCart();
    var customerId = userBloc.user.id;
    var supplierId = supplierBloc.supplierId;
    var location = locationBloc.customerLocation;

    await _db.createOrder(
      products,
      customerId,
      location.coordinates,
      location.address,
      nameController.text,
      phoneController.text,
      supplierId,
      driverId,
      selectedShift,
      paymentIntentId,
      noteController.text,
    );

    reset();
    return true;
  }

  void reset() {
    noteController.clear();
    nameController.clear();
    phoneController.clear();
  }
}
