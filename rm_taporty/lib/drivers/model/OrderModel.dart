import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
import 'package:mobile_app/model/OrderModel.dart';

part 'OrderModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DriverOrderModel extends FirebaseModel {
  final String titleR,titleS, addressR,addressS, timeR,timeS;
  final double latR,latS,lngS,lngR;
  String id, time;
  StateCategory state;

  DriverOrderModel({ String path,
    @required this.id, @required this.time,
    @required this.titleR,@required this.titleS,
    @required this.addressS,@required this.addressR,
    @required this.timeS,@required this.timeR,
    @required this.latR,@required this.latS,
    @required this.lngR,@required this.lngS,
    @required this.state,
  }):super(path);

  List<LatLng> get positions => [new LatLng(latS,lngS), new LatLng(latR,lngR)];
  List<SubjectModel> get subjects => [new SubjectModel(title: timeS,address: addressS,time: timeS,position: new LatLngModel(lat: latS, lng: lngS)),
    new SubjectModel(title: timeR,address: addressR,time: timeR,position: new LatLngModel(lat: latR, lng: lngR))];

  static DriverOrderModel fromJson(Map json) => _$DriverOrderModelFromJson(json);
  static DriverOrderModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$DriverOrderModelToJson(this);
  @required
  String toString() => toJson().toString();
}