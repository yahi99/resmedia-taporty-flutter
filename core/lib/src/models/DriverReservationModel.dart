import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/helper/GeopointSerialization.dart';

part "DriverReservationModel.g.dart";

@JsonSerializable(anyMap: true, explicitToJson: true)
class DriverReservationModel {
  final String driverId;
  bool available;

  // Coordinate e valutazione del fattorino
  @JsonKey(fromJson: geopointFromJson, toJson: geopointToJson)
  final GeoPoint geopoint;
  final double rating;

  @JsonKey(ignore: true)
  double totalDistance;

  DriverReservationModel(
    this.driverId,
    this.available,
    this.geopoint,
    this.rating,
  );

  static DriverReservationModel fromJson(Map json) => _$DriverReservationModelFromJson(json);
  Map<String, dynamic> toJson() => _$DriverReservationModelToJson(this);
}
