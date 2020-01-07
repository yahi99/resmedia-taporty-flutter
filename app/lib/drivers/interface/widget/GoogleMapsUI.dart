import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/services/platform_channel.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

typedef ValueChangedWidgetBuilder<V>(BuildContext context, V value);

class GoogleMapsBuilder extends StatelessWidget {
  final containerController = Completer<GoogleMapController>();
  final EdgeInsets padding;
  final ValueChangedWidgetBuilder<MapCreatedCallback> builder;

  GoogleMapsBuilder({Key key, @required this.builder, this.padding: const EdgeInsets.all(16.0)})
      : assert(builder != null),
        super(key: key); // 17

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        builder(context, containerController.complete),
        FutureBuilder<GoogleMapController>(
            future: containerController.future,
            builder: (_context, snap) {
              if (snap.data == null) {
                debugPrint("NULL");
                return Container();
              }
              debugPrint("Build UI");
              return GoogleMapsUI(
                padding: padding,
                controller: snap.data,
              );
            }),
      ],
    );
  }
}

class GoogleMapExt extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final ValueChanged<GoogleMapExtController> onMapCreated;

  GoogleMapExt({
    Key key,
    @required this.initialCameraPosition,
    @required this.onMapCreated,
  })  : assert(initialCameraPosition != null),
        assert(onMapCreated != null),
        super(key: key);

  @override
  _GoogleMapExtState createState() => _GoogleMapExtState();
}

class _GoogleMapExtState extends State<GoogleMapExt> {
  GoogleMapExtController _controller;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: _controller?.mapType,
      markers: _controller?.markers,
      polylines: _controller?.polylines,
      circles: _controller?.circles,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: (googleController) {
        widget.onMapCreated(_controller = GoogleMapExtController(
          googleController,
          setState,
        ));
      },
    );
  }
}

typedef UpdaterUI();

class GoogleMapExtController implements GoogleMapController {
  final GoogleMapController basicController;
  final ValueChanged<VoidCallback> _updaterUI;
  MapType _mapType;
  Set<Marker> _markers;
  Set<Polyline> _polylines;
  Set<Circle> _circles;

  GoogleMapExtController(
    this.basicController,
    this._updaterUI, {
    MapType mapType,
    Set<Marker> markers,
    Set<Polyline> polylines,
    Set<Circle> circles,
  })  : this._mapType = mapType,
        this._markers = markers,
        this._polylines = polylines,
        this._circles = circles;

  MapType get mapType => _mapType;

  set mapType(MapType mapType) => _updaterUI(() {
        _mapType = mapType;
      });

  Set<Marker> get markers => _markers;

  void setMarkers(Set<Marker> markers) async {
    _updaterUI(() {
      _markers = markers;
    });
  }

  Set<Polyline> get polylines => _polylines;

  set polylines(Set<Polyline> polylines) => _updaterUI(() {
        _polylines = polylines;
      });

  Set<Circle> get circles => _circles;

  set circles(Set<Circle> circles) => _updaterUI(() {
        _circles = circles;
      });

  update({
    MapType mapType,
    Set<Marker> markers,
    Set<Polyline> polylines,
    Set<Circle> circles,
  }) =>
      _updaterUI(() {
        if (mapType != null) this._mapType = mapType;
        if (markers != null) this._markers = markers;
        if (polylines != null) this._polylines = polylines;
        if (circles != null) this._circles = circles;
      });

  // ignore: invalid_use_of_visible_for_testing_member
  MethodChannel get channel => basicController.channel;

  Future<void> animateCamera(CameraUpdate cameraUpdate) async => await basicController.animateCamera(cameraUpdate);

  Future<void> moveCamera(CameraUpdate cameraUpdate) async => await basicController.moveCamera(cameraUpdate);

  Future<LatLngBounds> getVisibleRegion() async => await basicController.getVisibleRegion();

  Future<void> animateToCenter(Iterable<LatLng> positions, {padding: 48.0}) async {
    await animateCamera(CameraUpdate.newLatLngBounds(squarePos(markers.map((m) => m.position)), padding));
  }

  @override
  Future<void> setMapStyle(String mapStyle) {
    return null;
  }

  @override
  Future<LatLng> getLatLng(ScreenCoordinate screenCoordinate) {
    return null;
  }

  @override
  Future<ScreenCoordinate> getScreenCoordinate(LatLng latLng) {
    return null;
  }
}

LatLng centerPos(Iterable<LatLng> positions) {
  final sum = positions.fold<LatLng>(LatLng(0.0, 0.0), (prev, val) {
    return LatLng(prev.latitude + val.latitude, prev.longitude + val.longitude);
  });
  return LatLng(sum.latitude / positions.length, sum.longitude / positions.length);
}

LatLngBounds squarePos(Iterable<LatLng> positions) {
  return LatLngBounds(
    northeast: positions.fold(positions.elementAt(0), (prev, val) {
      return comparatorPos([prev, val], math.max);
    }),
    southwest: positions.fold(positions.elementAt(0), (prev, val) {
      return comparatorPos([prev, val], math.min);
    }),
  );
}

LatLng comparatorPos(Iterable<LatLng> positions, double comparator(double val1, double val2)) {
  return positions.fold(positions.elementAt(0), (prev, val) {
    return LatLng(comparator(prev.latitude, val.latitude), comparator(prev.longitude, val.longitude));
  });
}

class PrimaryGoogleMapsController extends InheritedWidget {
  final Completer<GoogleMapExtController> controller;

  PrimaryGoogleMapsController({
    Key key,
    this.controller,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static Completer<GoogleMapExtController> of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(PrimaryGoogleMapsController) as PrimaryGoogleMapsController)?.controller;
  }

  @override
  bool updateShouldNotify(PrimaryGoogleMapsController old) {
    return true;
  }
}

class GoogleMapsUI extends StatelessWidget {
  final GoogleMapController controller;
  final EdgeInsets padding;

  const GoogleMapsUI({
    Key key,
    @required this.controller,
    this.padding: const EdgeInsets.all(16.0),
  })  : assert(controller != null),
        super(key: key);

  void _onMapZoomIn() async {
    await controller.animateCamera(CameraUpdate.zoomIn());
  }

  void _onMapZoomOut() async {
    await controller.animateCamera(CameraUpdate.zoomOut());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Positioned(
            bottom: 0.0,
            right: 0.0,
            child: Material(
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  IconButton(
                    onPressed: _onMapZoomIn,
                    icon: const Icon(Icons.add, size: 36.0),
                  ),
                  SizedBox(
                      width: 32,
                      child: Divider(
                        height: 4,
                      )),
                  IconButton(
                    onPressed: _onMapZoomOut,
                    icon: const Icon(Icons.remove, size: 36.0),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/*void launchGoogleMaps(double latitude, double longitude) async {
  final url = 'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  if (await launcher.canLaunch(url)) {
    await launcher.launch(url);
  } else {
    throw 'Could not launch $url';
  }
}*/
