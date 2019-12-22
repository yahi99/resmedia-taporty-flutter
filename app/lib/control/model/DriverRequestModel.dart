import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'DriverRequestModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DriverRequestModel extends FirebaseModel {
  String codiceFiscale,address,mezzo,experience,nominative;
  double lat,lng,km;

  DriverRequestModel({
    String path,
    @required this.lat,@required this.address,@required this.codiceFiscale,
    @required this.mezzo,@required this.experience,
    @required this.km,@required this.nominative,@required this.lng}) : super(path);

  static DriverRequestModel fromJson(Map json) =>
      _$DriverRequestModelFromJson(json);

  static DriverRequestModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$DriverRequestModelToJson(this);

  @required
  String toString() => toJson().toString();
}