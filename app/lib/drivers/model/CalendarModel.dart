import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'CalendarModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class CalendarModel extends FirebaseModel {
  final String startTime, endTime, day;
  final List<String> free;
  final List<String> occupied;
  final bool isEmpty;

  CalendarModel({
    String path,
    @required this.isEmpty,
    @required this.startTime,
    @required this.day,
    @required this.endTime,
    @required this.free,
    @required this.occupied,
  }) : super(path);

  DateTime getDate() {
    return DateTime.tryParse(day);
  }

  static CalendarModel fromJson(Map json) => _$CalendarModelFromJson(json);

  static CalendarModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);

  @required
  String toString() => toJson().toString();
}
