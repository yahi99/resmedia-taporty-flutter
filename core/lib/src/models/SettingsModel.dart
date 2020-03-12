import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';

part "SettingsModel.g.dart";

@JsonSerializable(anyMap: true, explicitToJson: true)
class SettingsModel {
  final double supplierPercentage;
  final double driverAmount;
  final double deliveryAmount;

  SettingsModel(this.supplierPercentage, this.deliveryAmount, this.driverAmount);

  static SettingsModel fromJson(Map json) => _$SettingsModelFromJson(json);
  Map<String, dynamic> toJson() => _$SettingsModelToJson(this);
  static SettingsModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);
}
