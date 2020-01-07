import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_flutter/common/helper/GeopointSerialization.dart';

part 'DriverReservationModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DriverReservationModel extends FirebaseModel {
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime reserveTimestamp;
  final bool occupied;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint driverCoordinates;
  final double deliveryRadius;

  DriverReservationModel({
    String path,
    this.reserveTimestamp,
    this.occupied,
    this.driverCoordinates,
    this.deliveryRadius,
  }) : super(path);

  static DriverReservationModel fromJson(Map json) => _$DriverReservationModelFromJson(json);

  static DriverReservationModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$DriverReservationModelToJson(this);

  @required
  String toString() => toJson().toString();
}
