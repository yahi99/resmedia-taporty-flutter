import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/base/UserFirebaseModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class UserModel extends UserFirebaseModel {
  final String nominative;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final bool notifyApp;
  final LocationModel lastLocation;

  UserModel({
    String path,
    String fcmToken,
    this.imageUrl,
    this.nominative,
    this.email,
    this.phoneNumber,
    this.notifyApp,
    this.lastLocation,
  }) : super(path: path, fcmToken: fcmToken);

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);

  static UserModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
