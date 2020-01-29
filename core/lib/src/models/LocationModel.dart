import 'package:cloud_firestore/cloud_firestore.dart';

class LocationModel {
  GeoPoint coordinates;
  String address;

  LocationModel(this.address, this.coordinates);
}
