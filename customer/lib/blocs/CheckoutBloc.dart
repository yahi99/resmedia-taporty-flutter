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
import 'package:tuple/tuple.dart';

class CheckoutBloc extends Bloc {
  final DatabaseService _db = DatabaseService();
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
  }

  CheckoutBloc.instance() {
    noteController = TextEditingController();
    nameController = TextEditingController();
    phoneController = TextEditingController();
    _selectedDateController = BehaviorSubject.seeded(DateTimeHelper.getDay(DateTime.now()));
    _selectedShiftController = BehaviorSubject.seeded(null);
    _availableShiftListController = BehaviorController.catchStream(
        source: CombineLatestStream.combine3(
      _selectedDateController.stream,
      supplierBloc.outSupplierId,
      locationBloc.outCustomerLocation,
      (DateTime _selectedDate, String _supplierId, LocationModel _location) => Tuple3(_selectedDate, _supplierId, _location.coordinates),
    ).switchMap((tuple) {
      return ConcatStream([Stream.value(null), Stream.fromFuture(_db.getAvailableShifts(tuple.item1, tuple.item2, tuple.item3))]);
    }));
    _availableShiftSub = _availableShiftListController.listen((shifts) => _selectedShiftController.value = (shifts == null) ? null : (shifts.isNotEmpty ? shifts.first : null));
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

  Future<String> findDriver() async {
    var supplierId = cartBloc.supplierId;
    var customerCoordinates = locationBloc.customerLocation.coordinates;
    return _db.findDriver(selectedShift, supplierId, customerCoordinates);
  }

  Future<bool> confirmOrder(String driverId) async {
    assert(selectedShift != null);
    assert(stripeBloc.source != null);

    var products = cartBloc.clearCart();
    var customerId = userBloc.user.id;
    var supplierId = cartBloc.supplierId;
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
      stripeBloc.source.token,
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
