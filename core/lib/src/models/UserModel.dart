import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';

part 'UserModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class UserModel extends UserFirebaseModel {
  final String nominative;
  final String email;
  final String phoneNumber;
  final String imageUrl;
  final bool notifyEmail;
  final bool notifySms;
  final bool notifyApp;
  final bool offersEmail;
  final bool offersSms;
  final bool offersApp;

  UserModel({
    String path,
    String fcmToken,
    this.imageUrl,
    this.nominative,
    this.email,
    this.phoneNumber,
    this.notifyApp,
    this.notifyEmail,
    this.notifySms,
    this.offersApp,
    this.offersEmail,
    this.offersSms,
  }) : super(path: path, fcmToken: fcmToken);

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);

  static UserModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
