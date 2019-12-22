import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'RestaurantModel.g.dart';

const RULES = 'rules';

@JsonSerializable(anyMap: true, explicitToJson: true)
class RestaurantModel extends FirebaseModel {
  final String title, description;
  final String img, type;
  final double lat;
  final double lng;
  final double km,deliveryFee;
  final Map<String,String> lunch,dinner;
  final bool isDisabled;
  final int numberOfReviews;
  final double averageReviews;

  RestaurantModel({
    @required String path,
    this.isDisabled,
    this.lunch,
    this.dinner,
    this.deliveryFee,
    this.averageReviews,
    this.numberOfReviews,
    @required this.title,
    @required this.description,
    @required this.type,
    @required this.img,
    @required this.lng,
    @required this.lat,
    @required this.km,
  }) : super(path);

  LatLng getPos() {
    return (lat != null && lng != null) ? LatLng(lat, lng) : null;
  }

  static RestaurantModel fromJson(Map json) => _$RestaurantModelFromJson(json);

  static RestaurantModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
