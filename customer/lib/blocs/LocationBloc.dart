import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class LocationBloc implements Bloc {
  @protected
  dispose() {
    _locationController.close();
  }

  BehaviorSubject<LocationModel> _locationController = BehaviorSubject.seeded(null);

  Stream<LocationModel> get outCustomerLocation => _locationController.stream;

  LocationBloc.instance();

  void setLocation(String customerAddress, GeoPoint customerCoordinates) {
    _locationController.value = LocationModel(customerAddress, customerCoordinates);
  }
}
