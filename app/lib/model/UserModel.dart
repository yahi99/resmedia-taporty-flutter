import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
part 'UserModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class UserModel extends UserFirebaseModel {
  @JsonKey(includeIfNull: false)
  final String nominative;
  @JsonKey(includeIfNull: false)
  final String email;
  @JsonKey(includeIfNull: false)
  final int phoneNumber;
  @JsonKey(includeIfNull: false)
  final String restaurantId;
  final bool notifyEmail;
  final bool notifySms;
  final bool notifyApp;
  final bool offersEmail;
  final bool offersSms;
  final bool offersApp;
  final double lat;
  final double lng;
  final bool isDriver;

  UserModel({
    String path, String fcmToken,
    this.lat,
    this.lng,
    this.isDriver,
    this.restaurantId,
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

  LatLng getPos(){
    return (lat!=null && lng!=null)?LatLng(lat, lng):null;
  }

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);
  static UserModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}


class User extends UserBase<UserModel> {
  User(FirebaseUser userFb, UserModel model) : super(userFb, model);
}