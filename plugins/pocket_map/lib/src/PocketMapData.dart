import 'package:google_maps_flutter/google_maps_flutter.dart';


class PocketMapData {
  final MapType mapType;
  final Set<Marker> markers;
  final Set<Polyline> polylines;
  final Set<Circle> circles;

  const PocketMapData({this.mapType, this.markers, this.polylines, this.circles});

  PocketMapData copyWith({
    MapType mapType, Set<Marker> markers, Set<Polyline> polylines, Set<Circle> circles,
  }) {
    return PocketMapData(
      mapType: mapType??this.mapType,
      markers: markers??this.markers,
      polylines: polylines??this.polylines,
      circles: circles??this.circles,
    );
  }


}