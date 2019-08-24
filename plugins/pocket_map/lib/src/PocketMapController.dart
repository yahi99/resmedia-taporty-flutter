import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapData.dart';
import 'package:pocket_map/src/PocketMapUtility.dart';


class PocketMapController implements GoogleMapController {
  final GoogleMapController basicController;
  final ValueChanged<PocketMapData> _updaterData;
  PocketMapData data;

  PocketMapController(this.basicController, this._updaterData, {
    this.data: const PocketMapData(),
  });

  void updateData({
    MapType mapType, Set<Marker> markers, Set<Polyline> polylines, Set<Circle> circles,
  }) {
    setData(data.copyWith(
      mapType: mapType, markers: markers, polylines: polylines, circles: circles,
    ));
  }

  void setData([PocketMapData data = const PocketMapData()]) {
    this.data = data;
    _updaterData(data);
  }

  // ignore: invalid_use_of_visible_for_testing_member
  MethodChannel get channel => basicController.channel;
  Future<void> animateCamera(CameraUpdate cameraUpdate) async => await basicController.animateCamera(cameraUpdate);
  Future<void> moveCamera(CameraUpdate cameraUpdate) async => await basicController.moveCamera(cameraUpdate);
  Future<LatLngBounds> getVisibleRegion() async => await basicController.getVisibleRegion();

  Future<void> animateToCenter(Iterable<LatLng> positions, {padding: 48.0}) async {
    await animateCamera(CameraUpdate.newLatLngBounds(PocketMapUtility.squarePos(
        data.markers.map((m) => m.position)
    ), padding));
  }

  @override
  Future<void> setMapStyle(String mapStyle) {
    // TODO: implement setMapStyle
    return null;
  }
}