import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/GeohashPointModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';

part 'ShiftModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false, nullable: true)
class ShiftModel extends FirebaseModel {
  @JsonKey(toJson: datetimeToTimestamp, fromJson: datetimeFromTimestamp)
  final DateTime startTime;
  @JsonKey(toJson: datetimeToTimestamp, fromJson: datetimeFromTimestamp)
  final DateTime endTime;

  final String driverId;
  final GeohashPointModel geohashPoint;
  final bool occupied;
  final double rating;

  String get id => driverId + startTime.millisecondsSinceEpoch.toString();

  ShiftModel({
    String path,
    @required this.endTime,
    @required this.startTime,
    this.driverId,
    this.geohashPoint,
    this.occupied,
    this.rating,
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
