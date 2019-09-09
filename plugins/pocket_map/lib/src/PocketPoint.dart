import 'package:pocket_map/pocket_map.dart';
import 'package:json_annotation/json_annotation.dart';

@JsonSerializable(explicitToJson: true)
class PocketPoint extends LatLng {
  static const lat = 'lat';
  static const lng = 'lng';

  const PocketPoint(double latitude, double longitude) : super(latitude, longitude);

  static PocketPoint fromJson(Map map) => PocketPoint(map[lat] as double, map[lng] as double);
  Map<String, double> toJson() => {lat: latitude, lng: longitude};
}