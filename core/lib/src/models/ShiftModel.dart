import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_core/src/helper/GeopointSerialization.dart';

part 'ShiftModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false, nullable: true)
class ShiftModel extends FirebaseModel {
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime startTime;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime endTime;

  final String driverId;
  final double deliveryRadius;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint driverCoordinates;
  final bool occupied;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime reservationTimestamp;

  String get id => driverId + startTime.millisecondsSinceEpoch.toString();

  ShiftModel({
    String path,
    @required this.endTime,
    @required this.startTime,
    this.driverId,
    this.deliveryRadius,
    this.driverCoordinates,
    this.occupied,
    this.reservationTimestamp,
  }) : super(path);

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(o) => o is ShiftModel && o.startTime == startTime && o.endTime == endTime;

  static ShiftModel fromJson(Map json) => _$ShiftModelFromJson(json);

  static ShiftModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);

  @required
  String toString() => toJson().toString();
}
