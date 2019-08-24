import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:dash/dash.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:rxdart/rxdart.dart';


class DriverBloc implements Bloc {
  @protected
  static DriverBloc instance() => DriverBloc();

  @protected
  @override
  void dispose() {
    _cameraControl.close();
  }

  final PublishSubject<LatLng> _cameraControl = PublishSubject();
  Stream<LatLng> get outCamera => _cameraControl.stream;

  static DriverBloc of() => $Provider.of<DriverBloc>();
  void close() => $Provider.dispose<DriverBloc>();
}
