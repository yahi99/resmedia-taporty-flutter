import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_flutter/common/helper/GeopointSerialization.dart';

part 'UserModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class UserModel extends UserFirebaseModel {
  final String nominative;
  final String email;
  final String phoneNumber;
  final int numberOfReviews;
  final double averageReviews;
  final String imageUrl;
  final bool notifyEmail;
  final bool notifySms;
  final bool notifyApp;
  final bool offersEmail;
  final bool offersSms;
  final bool offersApp;
  // TODO: Usare i custom claims per rappresentare il ruolo di un utente
  final String type;

  // Driver specific values
  @JsonKey(fromJson: geopointFromJson, toJson: geopointToJson)
  final GeoPoint coordinates;
  final String address;
  final double deliveryRadius;

  UserModel({
    String path,
    String fcmToken,
    this.imageUrl,
    this.numberOfReviews,
    this.averageReviews,
    this.type,
    this.nominative,
    this.email,
    this.phoneNumber,
    this.notifyApp,
    this.notifyEmail,
    this.notifySms,
    this.offersApp,
    this.offersEmail,
    this.offersSms,
    this.coordinates,
    this.address,
    this.deliveryRadius,
  }) : super(path: path, fcmToken: fcmToken);

  LatLng getPos() {
    return (coordinates != null) ? LatLng(coordinates.latitude, coordinates.longitude) : null;
  }

  static UserModel fromJson(Map json) => _$UserModelFromJson(json);

  static UserModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}

// TODO: Elimina e rivedi il funzionamento dell'UserBloc
class User extends UserBase<UserModel> {
  User(FirebaseUser userFb, UserModel model) : super(userFb, model);
}
