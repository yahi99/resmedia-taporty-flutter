import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapView.dart';


typedef Widget ValueChangedWidgetBuilder<V>(BuildContext context, V value);


class PocketMapBuilder extends StatelessWidget {
  final containerController = Completer<GoogleMapController>();
  final EdgeInsets padding;
  final ValueChangedWidgetBuilder<MapCreatedCallback> builder;

  PocketMapBuilder({Key key, @required this.builder, this.padding: const EdgeInsets.all(16.0)}) : assert(builder != null), super(key: key); // 17

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
              return PocketMapView(
                padding: padding,
                controller: snap.data,
              );
            }
        ),
      ],
    );
  }
}