import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc implements Bloc {
  final _db = DatabaseService();
  final _userBloc = $Provider.of<UserBloc>();

  @protected
  dispose() {
    _locationController.close();
  }

  BehaviorSubject<LocationModel> _locationController = BehaviorSubject.seeded(null);

  Stream<LocationModel> get outCustomerLocation => _locationController.stream;
  LocationModel get customerLocation => _locationController.value;

  LocationBloc.instance();

  void initLocation(LocationModel location) {
    _locationController.value = location;
  }

  Future setLocation(String customerAddress, String customerShortAddress, GeoPoint customerCoordinates) async {
    LocationModel location = _locationController.value = LocationModel(customerAddress, customerShortAddress, customerCoordinates);
    await _db.updateLastLocation(_userBloc.user.id, location);
  }
}
