import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
import 'package:mobile_app/model/OrderModel.dart';

part 'TurnModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class TurnModel extends FirebaseModel {
  final String startTime,endTime,day;
  MonthCategory month;

  TurnModel({ String path,
    @required this.startTime,@required this.month,
    @required this.day,@required this.endTime,
  }):super(path);

  static TurnModel fromJson(Map json) => _$TurnModelFromJson(json);
  static TurnModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$TurnModelToJson(this);
  @required
  String toString() => toJson().toString();
}

enum MonthCategory {
  JANUARY,FEBRUARY,MARCH,APRIL,MAY,JUNE,JULY,AUGUST,SEPTEMBER,OCTOBER,NOVEMBER,DECEMBER
}

String translateMonthCategory(MonthCategory category) {
  switch (category) {
    case MonthCategory.APRIL:
      return "APRILE";
    case MonthCategory.AUGUST:
      return "AGOSTO";
    case MonthCategory.DECEMBER:
      return "DICEMBRE";
    case MonthCategory.FEBRUARY:
      return "FEBBRAIO";
    case MonthCategory.JANUARY:
      return "GENNAIO";
    case MonthCategory.JULY:
      return "LUGLIO";
    case MonthCategory.JUNE:
      return "GIUGNO";
    case MonthCategory.MARCH:
      return "MARZO";
    case MonthCategory.MAY:
      return "MAGGIO";
    case MonthCategory.NOVEMBER:
      return "NOVEMBRE";
    case MonthCategory.OCTOBER:
      return "oTTOBRE";
    case MonthCategory.SEPTEMBER:
      return "SETTEMBRE";
    default: return "";
  }
}