import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapController.dart';


class PocketMapView extends StatelessWidget {
  final PocketMapController controller;
  final EdgeInsets padding;

  const PocketMapView({Key key,
    @required this.controller, this.padding: const EdgeInsets.all(16.0),
  }) : assert(controller != null), super(key: key);


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
          Align(
            alignment: Alignment.topRight,
            child: Material(
              elevation: 4,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget> [
                  IconButton(
                    onPressed: _onMapZoomIn,
                    icon: const Icon(Icons.add, size: 36.0),
                  ),
                  SizedBox(
                    width: 36.0,
                    child: Divider(height: 0,),
                  ),
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