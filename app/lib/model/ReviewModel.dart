import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ReviewModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ReviewModel extends FirebaseModel {
  final double points;
  final String strPoints,oid,userId,nominative;

  ReviewModel({
    @required String path,
    @required this.nominative,
    @required this.strPoints,
    @required this.userId,
    @required this.oid,
    @required this.points,
  }) : super(path);

  static ReviewModel fromJson(Map json) => _$ReviewModelFromJson(json);

  static ReviewModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
