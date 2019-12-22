import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'IncomeModel.g.dart';

const RULES = 'rules';

@JsonSerializable(anyMap: true, explicitToJson: true)
class IncomeModel extends FirebaseModel {
  final int totalTransactions;
  final double dailyTotal;
  final String day;

  IncomeModel({
    this.day,
    this.dailyTotal,
    this.totalTransactions,
    @required String path,
  }) : super(path);

  static IncomeModel fromJson(Map json) => _$IncomeModelFromJson(json);

  static IncomeModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$IncomeModelToJson(this);
}
