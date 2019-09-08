import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:math' as math;


class PocketMapUtility {
  static const BASE_URL = "https://maps.googleapis.com/maps/api/directions/json?";

  static PocketMapUtility _instance;

  factory PocketMapUtility(String googleMapsKey) {
    assert(googleMapsKey != null);
    return _instance??(_instance=PocketMapUtility._(googleMapsKey));
  }

  PocketMapUtility._(this._key);

  final String _key;

  String _getUrl(String url) {
    return BASE_URL+url+"&key=$_key";
  }

  Future<http.Response> _get(url) async => await http.get(_getUrl(url));

  posToStr(LatLng position) => """${position.latitude},${position.longitude}""";

  Future<List<LatLng>> getPosToPos(LatLng departure, LatLng arrival) async {
    final url = """origin=${posToStr(departure)}&destination=${posToStr(arrival)}""";

    final response = await _get(url);
    String res = response.body;
    int statusCode = response.statusCode;
    //print("API Response: " + res);
    if (statusCode < 200 || statusCode > 400 || json == null) {
      res = """{"status":"$statusCode","message":"error","response":"$res"}""";
      throw Exception(res);
    }

    List<LatLng> steps;
    try {
      steps = parseSteps(jsonDecode(res)["routes"][0]["legs"][0]["steps"]);
    } catch (e) {
      throw Exception(res);
    }

    return steps;
  }

  List<LatLng> parseSteps(final responseBody) {
    return responseBody.map<LatLng>((json) => LatLng(json[0], json[1])).toList();
  }

  static LatLng centerPos(Iterable<LatLng> positions) {
    final sum = positions.fold<LatLng>(LatLng(0.0, 0.0), (prev, val) {
      return LatLng(prev.latitude+val.latitude, prev.longitude+val.longitude);
    });
    return LatLng(sum.latitude/positions.length, sum.longitude/positions.length);
  }

  static LatLngBounds squarePos(Iterable<LatLng> positions) {
    return LatLngBounds(
      northeast: positions.fold(positions.elementAt(0), (prev, val) {
        return comparatorPos([prev, val], math.max);
      }),
      southwest: positions.fold(positions.elementAt(0), (prev, val) {
        return comparatorPos([prev, val], math.min);
      }),
    );
  }

 static LatLng comparatorPos(Iterable<LatLng> positions, double comparator(double val1, double val2)) {
    return positions.fold(positions.elementAt(0), (prev, val) {
      return LatLng(comparator(prev.latitude, val.latitude), comparator(prev.longitude, val.longitude));
    });
  }
}