import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ShiftModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ShiftModel extends FirebaseModel {
  final List<String> users;
  final String startTime;

  //final List<bool> isOccupied;

  ShiftModel({
    String path,
    //@required this.isOccupied,
    @required this.users,
    @required this.startTime,
  }) : super(path);

  static ShiftModel fromJson(Map json) => _$ShiftModelFromJson(json);

  static ShiftModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);

  @required
  String toString() => toJson().toString();
}
