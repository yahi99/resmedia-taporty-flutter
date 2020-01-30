import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ReviewModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ReviewModel extends FirebaseModel {
  final double rating;
  final String description, orderId, userId, customerName;

  ReviewModel({
    @required String path,
    @required this.customerName,
    @required this.description,
    @required this.userId,
    @required this.orderId,
    @required this.rating,
  }) : super(path);

  static ReviewModel fromJson(Map json) => _$ReviewModelFromJson(json);

  static ReviewModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ReviewModelToJson(this);
}
