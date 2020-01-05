import 'package:cloud_firestore/cloud_firestore.dart';

GeoPoint geopointFromJson(Map<String, dynamic> input) {
  if (input == null) return null;
  return GeoPoint(input["latitude"] as double, input['longitude'] as double);
}

Map<String, dynamic> geopointToJson(GeoPoint input) {
  var map = Map<String, dynamic>();
  map.putIfAbsent("latitude", input.latitude as dynamic);
  map.putIfAbsent("longitude", input.longitude as dynamic);
  return map;
}
