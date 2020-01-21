import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';

class DistanceHelper {
  static final Geolocator geolocatorService = Geolocator();
  static Future<double> fetchAproximateDistance(GeoPoint pointA, GeoPoint pointB) async {
    return await geolocatorService.distanceBetween(pointA.longitude, pointA.latitude, pointB.longitude, pointB.latitude);
  }
}
