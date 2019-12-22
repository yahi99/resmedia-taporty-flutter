import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'RestaurantRequestModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class RestaurantRequestModel extends FirebaseModel {
  String img,address,partitaIva,prodType,tipoEsercizio,ragioneSociale;
  double lat,lng,km;

  RestaurantRequestModel({
    String path,
    @required this.lat,@required this.address,@required this.prodType,
    @required this.img,@required this.partitaIva,@required this.tipoEsercizio,
    @required this.km,@required this.ragioneSociale,@required this.lng}) : super(path);

  static RestaurantRequestModel fromJson(Map json) =>
      _$RestaurantRequestModelFromJson(json);

  static RestaurantRequestModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$RestaurantRequestModelToJson(this);

  @required
  String toString() => toJson().toString();
}