import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pocket_map/src/PocketMapData.dart';

import 'PocketMapController.dart';


class PocketMap extends StatefulWidget {
  final CameraPosition initialCameraPosition;
  final ValueChanged<PocketMapController> onMapCreated;
  final PocketMapData data;

  PocketMap({Key key,
    @required this.initialCameraPosition, @required this.onMapCreated,
    this.data: const PocketMapData(),
  }) : assert(initialCameraPosition != null),
        assert(onMapCreated != null),
        assert(data != null),
        super(key: key);

  @override
  _GoogleMapExtState createState() => _GoogleMapExtState();
}

class _GoogleMapExtState extends State<PocketMap> {
  PocketMapData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  void _updateData(PocketMapData data) {
    setState(() {
      _data = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: _data.mapType,
      markers: _data.markers,
      polylines: _data.polylines,
      circles: _data.circles,
      initialCameraPosition: widget.initialCameraPosition,
      onMapCreated: (googleController) {
        widget.onMapCreated(PocketMapController(
          googleController,
          _updateData,
        ));
      },
    );
  }
}


