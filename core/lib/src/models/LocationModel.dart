import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/helper/GeopointSerialization.dart';

part 'LocationModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class LocationModel {
  @JsonKey(fromJson: geopointFromJson, toJson: geopointToJson)
  GeoPoint coordinates;
  String address;
  String shortAddress;

  LocationModel(this.address, this.shortAddress, this.coordinates);

  static LocationModel fromJson(Map json) => _$LocationModelFromJson(json);
  Map<String, dynamic> toJson() => _$LocationModelToJson(this);
}
