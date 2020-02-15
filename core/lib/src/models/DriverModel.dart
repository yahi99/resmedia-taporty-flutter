import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/models/GeohashPointModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:resmedia_taporty_core/src/models/base/UserFirebaseModel.dart';

part 'DriverModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DriverModel extends UserFirebaseModel {
  final String nominative;
  final String email;
  final String phoneNumber;
  final int numberOfReviews;
  final double rating;
  final String imageUrl;

  final GeohashPointModel geohashPoint;
  final String address;

  DriverModel({
    String path,
    String fcmToken,
    this.imageUrl,
    this.numberOfReviews,
    this.rating,
    this.nominative,
    this.email,
    this.phoneNumber,
    this.geohashPoint,
    this.address,
  }) : super(path: path, fcmToken: fcmToken);

  static DriverModel fromJson(Map json) => _$DriverModelFromJson(json);

  static DriverModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$DriverModelToJson(this);
}
