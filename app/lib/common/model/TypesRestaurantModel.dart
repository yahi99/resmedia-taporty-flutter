import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'TypesRestaurantModel.g.dart';

const String IMG_PATH = 'img_path', TITLE = 'title';

@JsonSerializable(anyMap: true, explicitToJson: true)
class TypesRestaurantModel extends FirebaseModel {
  final String img;

  TypesRestaurantModel({@required String path, @required this.img})
      : super(path);

  static TypesRestaurantModel fromJson(Map json) =>
      _$TypesRestaurantModelFromJson(json);

  static TypesRestaurantModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$TypesRestaurantModelToJson(this);
}
