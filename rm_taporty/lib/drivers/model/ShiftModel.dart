import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
import 'package:mobile_app/model/OrderModel.dart';

part 'ShiftModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ShiftModel extends FirebaseModel {
  final List<String> users;
  final String startTime;

  ShiftModel({ String path,
    @required this.users,
    @required this.startTime,
  }):super(path);

  static ShiftModel fromJson(Map json) => _$ShiftModelFromJson(json);
  static ShiftModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$ShiftModelToJson(this);
  @required
  String toString() => toJson().toString();
}