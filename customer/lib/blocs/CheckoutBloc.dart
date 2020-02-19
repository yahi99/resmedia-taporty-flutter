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
import 'package:tuple/tuple.dart';
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
    _availableShiftListController = BehaviorSubject.seeded(null);

    _availableShiftSub = CombineLatestStream.combine2(
      _selectedDateController.stream,
      supplierBloc.outSupplierId,
      (DateTime _selectedDate, String _supplierId) => Tuple2(
        _selectedDate,
        _supplierId,
      ),
    ).listen((tuple) async {
      _availableShiftListController.value = null;
      _selectedShiftController.value = null;
      if (tuple.item1 == null || tuple.item2 == null) return;
      SupplierModel supplier = await supplierBloc.outSupplier.first;

      if (supplier == null) return;
      var shifts = _availableShiftListController.value = await _getAvailableShifts(tuple.item1, supplier);
      _selectedShiftController.value = shifts.isNotEmpty ? shifts.first : null;
    });
  }

  Future<List<ShiftModel>> _getAvailableShifts(DateTime day, SupplierModel supplier) async {
    var startTimes = supplier.getShiftStartTimes(day);
    var filteredShifts = List<ShiftModel>();

    /* 
      Non è possibile richiedere un orario di consegna entro la prossima ora o oltre le 47 ore 
      (per evitare il caso il cliente stia nel checkout per molto tempo)
    */
    startTimes = startTimes.where((startTime) {
      var diff = startTime.difference(DateTime.now());
      return diff.inHours > 1 && diff.inHours <= 47;
    }).toList();

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
      var orderId = randomNumeric(10);
      var paymentIntentId = await _processPayment(orderId);
      var driverId = await _findDriver();
      await _confirmOrder(driverId, paymentIntentId, orderId);
    } catch (err) {
      _confirmLoadingController.value = false;
      throw err;
    }

    return true;
  }

  Future<String> _processPayment(String orderId) async {
    var result = await _functions.createPaymentIntent(stripeBloc.paymentMethod.id, cartBloc.cart.totalPrice, orderId);
    var confirmPaymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
      clientSecret: result.clientSecret,
      paymentMethodId: stripeBloc.paymentMethod.id,
    ));
    if (confirmPaymentResult.status != 'requires_capture') throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    return confirmPaymentResult.paymentIntentId;
  }

  Future<String> _findDriver() async {
    var supplierId = supplierBloc.supplierId;
    var supplier = supplierBloc.supplier;

    var driverId = await _db.chooseDriver(datetimeToTimestamp(selectedShift.startTime), supplierId, supplier.geohashPoint.geopoint);
    if (driverId == null) throw new NoAvailableDriverException("No available drivers found.");
    return driverId;
  }

  Future<bool> _confirmOrder(String driverId, String paymentIntentId, String orderId) async {
    assert(selectedShift != null);
    assert(stripeBloc.paymentMethod != null);

    var products = cartBloc.clearCart();
    var customerId = userBloc.user.id;
    var supplierId = supplierBloc.supplierId;
    var location = locationBloc.customerLocation;

    await _db.createOrder(
      orderId,
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
