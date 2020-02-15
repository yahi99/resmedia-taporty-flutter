import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/helper/GeopointSerialization.dart';

part "GeohashPointModel.g.dart";

@JsonSerializable(anyMap: true, explicitToJson: true)
class GeohashPointModel {
  final String geohash;
  @JsonKey(fromJson: geopointFromJson, toJson: geopointToJson)
  final GeoPoint geopoint;

  GeohashPointModel(this.geohash, this.geopoint);

  static GeohashPointModel fromJson(Map json) => _$GeohashPointModelFromJson(json);
  Map<String, dynamic> toJson() => _$GeohashPointModelToJson(this);
}
