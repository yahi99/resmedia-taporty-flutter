import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ControlUsersModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ControlUsersModel extends FirebaseModel {
  List<String> users;

  ControlUsersModel({
    String path,
    @required this.users}) : super(path);

  static ControlUsersModel fromJson(Map json) =>
      _$ControlUsersModelFromJson(json);

  static ControlUsersModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ControlUsersModelToJson(this);

  @required
  String toString() => toJson().toString();
}