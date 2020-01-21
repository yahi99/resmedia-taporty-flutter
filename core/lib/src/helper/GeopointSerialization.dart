import 'package:cloud_firestore/cloud_firestore.dart';

GeoPoint geopointFromJson(dynamic input) {
  return input as GeoPoint;
}

geopointToJson(GeoPoint input) {
  return input;
}
