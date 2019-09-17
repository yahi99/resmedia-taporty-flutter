import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductRequestModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ProductRequestModel extends FirebaseModel {
  String cat,category,img,price,quantity,restaurantId;

  ProductRequestModel({
    String path,
    @required this.cat,@required this.category,
    @required this.img,@required this.price,
    @required this.quantity,@required this.restaurantId
  }) : super(path);

  static ProductRequestModel fromJson(Map json) =>
      _$ProductRequestModelFromJson(json);

  static ProductRequestModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ProductRequestModelToJson(this);

  @required
  String toString() => toJson().toString();
}