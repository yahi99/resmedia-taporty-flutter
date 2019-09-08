import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'SubjectModel.g.dart';

@JsonSerializable()
class SubjectModel {
  final String title, address, time;
  final LatLngModel position;

  SubjectModel({
    @required this.title, @required this.address, @required this.time,
    @required this.position,
  });

  LatLng toLatLng(){
    return LatLng(position.lat,position.lng);
  }

  factory SubjectModel.fromJson(Map<String,dynamic> json) => _$SubjectModelFromJson(json);

  Map<String,dynamic> toJson() => _$SubjectModelToJson(this);
}

@JsonSerializable()
class LatLngModel {
  final double lat,lng;

  LatLng toLatLng(){
    return LatLng(lat,lng);
  }

  LatLngModel({
    @required this.lat, @required this.lng,
  });

  factory LatLngModel.fromJson(Map<String,dynamic> json) => _$LatLngModelFromJson(json);

  Map<String,dynamic> toJson() => _$LatLngModelToJson(this);
}