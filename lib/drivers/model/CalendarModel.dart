import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
import 'package:mobile_app/model/OrderModel.dart';

part 'CalendarModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class CalendarModel extends FirebaseModel {
  final String startTime,endTime,day;
  final List<String> users;
  final bool isEmpty;

  CalendarModel({ String path,
    @required this.isEmpty,
    @required this.startTime,
    @required this.day,@required this.endTime,
    @required this.users,
  }):super(path);

  DateTime getDate(){
    return DateTime.tryParse(day);
  }

  static CalendarModel fromJson(Map json) => _$CalendarModelFromJson(json);
  static CalendarModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$CalendarModelToJson(this);
  @required
  String toString() => toJson().toString();
}