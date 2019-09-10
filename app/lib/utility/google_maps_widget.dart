import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart';
import 'package:rxdart/rxdart.dart';

/// Questo file, abbastanza complesso, gestisce la funzionalità di Google Maps tramite BLoC.
/// Bisognerebbe farne un plugin, che renderebbe tutte le cose relativamente semplici.
/// Non è il caso di andare fieri di questa soluzione.

class GoogleMapsWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(milliseconds: 500), () {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text("Premi start per avviare la navigazione"),
        ),
      );
    });

    return StreamBuilder(
      stream: routeBloc.currentRoute,
      builder: (BuildContext context, AsyncSnapshot<RouteModel> routeSnapshot) {
        if (routeSnapshot.hasData) {
          return GoogleMap(
            myLocationEnabled: true,
            initialCameraPosition: CameraPosition(
                target: routeSnapshot.data.currentLocation, zoom: 6.0),
            markers: Set.from(<Marker>[
              Marker(
                markerId: MarkerId("Arrivo"),
                position: LatLng(
                    routeSnapshot.data.route.last.points.last.latitude,
                    routeSnapshot.data.route.last.points.last.longitude),
              )
            ]),
            polylines: routeSnapshot.data != null
                ? routeSnapshot.data.route
                : Set.from(<Polyline>[]),
            cameraTargetBounds: routeSnapshot.data != null
                ? CameraTargetBounds(routeSnapshot.data.bound)
                : CameraTargetBounds.unbounded,
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class RouteModel {
  LatLng currentLocation;
  LatLng startLocation;
  String startAddress;
  LatLng endLocation;
  String endAddress;

  LatLngBounds bound;
  List<LatLng> steps;
  Set<Polyline> route;

  String distanceKm;
  String durationM;

  String summary;
  String status;

  RouteModel({
    this.currentLocation,
    this.startLocation,
    this.startAddress,
    this.endLocation,
    this.endAddress,
    this.bound,
    this.steps,
    this.route,
    this.distanceKm,
    this.durationM,
    this.summary,
    this.status,
  });

  @override
  toString() => "Percorso da $startAddress a $endAddress.";

  factory RouteModel.fromJson(
      Map<String, dynamic> parsedJson, BuildContext context) {
    return RouteModel(
      startLocation: LatLng(
          parsedJson["routes"][0]["legs"][0]["start_location"]["lat"],
          parsedJson["routes"][0]["legs"][0]["start_location"]["lng"]),
      startAddress: parsedJson["routes"][0]["legs"][0]["start_address"],
      endLocation: LatLng(
          parsedJson["routes"][0]["legs"][0]["end_location"]["lat"],
          parsedJson["routes"][0]["legs"][0]["end_location"]["lng"]),
      endAddress: parsedJson["routes"][0]["legs"][0]["end_address"],
      bound: _parseBounds(parsedJson),
      steps: _parseSteps(parsedJson),
      route: _parseRoute(_parseSteps(parsedJson), context, parsedJson),
      distanceKm: parsedJson["routes"][0]["legs"][0]["distance"]["text"],
      durationM: parsedJson["routes"][0]["legs"][0]["duration"]["text"],
      summary: parsedJson["routes"][0]["summary"],
      status: parsedJson["status"],
    );
  }

  // Questo fa il parse dei bounds, molto utili in seguito.
  static LatLngBounds _parseBounds(Map<String, dynamic> parsedJson) {
    LatLng northeastBound = LatLng(
        parsedJson["routes"][0]["bounds"]["northeast"]["lat"],
        parsedJson["routes"][0]["bounds"]["northeast"]["lng"]);

    LatLng southwestBound = LatLng(
        parsedJson["routes"][0]["bounds"]["southwest"]["lat"],
        parsedJson["routes"][0]["bounds"]["southwest"]["lng"]);

    return LatLngBounds(northeast: northeastBound, southwest: southwestBound);
  }

  static List<LatLng> _parseSteps(Map<String, dynamic> parsedJson) {
    List<LatLng> waypoints = List<LatLng>();

    waypoints.add(LatLng(
        parsedJson["routes"][0]["legs"][0]["start_location"]["lat"],
        parsedJson["routes"][0]["legs"][0]["start_location"]["lng"]));
    for (int i = 0;
        i < parsedJson["routes"][0]["legs"][0]["steps"].length;
        i++) {
      waypoints.add(LatLng(
          parsedJson["routes"][0]["legs"][0]["steps"][i]["end_location"]["lat"],
          parsedJson["routes"][0]["legs"][0]["steps"][i]["end_location"]
              ["lng"]));
    }

    return waypoints;
  }

  static Set<Polyline> _parseRoute(List<LatLng> parsedSteps,
      BuildContext context, Map<String, dynamic> parsedJson) {
    List<PatternItem> patterns = List<PatternItem>();
    for (int i = 0; i < parsedSteps.length; i++) patterns.add(PatternItem.dot);

    return Set.from(<Polyline>[
      Polyline(
          polylineId: PolylineId(
              "${parsedJson["routes"][0]["legs"][0]["start_address"]}+${parsedJson["routes"][0]["legs"][0]["start_address"]}"),
          points: parsedSteps,
          color: Theme.of(context).accentColor,
          patterns: patterns),
    ]);
  }
}

class RouteBloc {
  final _routeFetcher = PublishSubject<RouteModel>();

  Observable<RouteModel> get currentRoute => _routeFetcher.stream;

  getRouteTo(LatLng start, LatLng end, BuildContext context) async {
    String rawCurrentLocation = "${start.latitude},${start.longitude}";

    String rawEnd = "${end.latitude},${end.longitude}";

    RouteModel routeModel =
        await RouteProvider.getRouteFromTo(rawCurrentLocation, rawEnd, context);

    routeModel.currentLocation = start;

    _routeFetcher.sink.add(routeModel);
  }

  clearRoute() async {
    debugPrint("Ripulita la mappa.");
    _routeFetcher.sink.add(RouteModel());
  }

  dispose() {
    _routeFetcher.close();
  }
}

final routeBloc = RouteBloc();

class RouteProvider {
  static Future<RouteModel> getRouteFromTo(
      var start, var end, BuildContext context) async {
    debugPrint(
        "${References.googleMapsUrl}&origin=$start&destination=$end&key=${References.googleMapsApiKey}");

    Response response = await get(
        "${References.googleMapsUrl}&origin=$start&destination=$end&key=${References.googleMapsApiKey}");

    if (response.statusCode == 200)
      return RouteModel.fromJson(json.decode(response.body), context);
    else
      throw Exception(
          "Impossibile stabilire una connessione con i server di Google Maps.");
  }
}

class References {
  static final String googleMapsApiKey =
      "AIzaSyAmJyflDR6W10z738vMkLz9Oham51HR790";
  static final String googleMapsUrl =
      "https://maps.googleapis.com/maps/api/directions/json?mode=driving";
}
