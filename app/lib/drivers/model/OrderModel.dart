import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

part 'OrderModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DriverOrderModel extends FirebaseModel {
  final String titleR, titleS, addressR, addressS, timeR, timeS;
  final double latR, lngR;
  String id, restId, uid, nominative,day,endTime,startTime,phone;
  StateCategory state;

  DriverOrderModel({
    String path,
    @required this.phone,
    @required this.day,
    @required this.startTime,
    @required this.endTime,
    @required this.id,
    @required this.titleR,
    @required this.titleS,
    @required this.addressS,
    @required this.addressR,
    this.timeS,
    @required this.timeR,
    @required this.latR,
    @required this.lngR,
    @required this.state,
    @required this.uid,
    @required this.restId,
  }) : super(path);

  List<LatLng> get positions => [LatLng(latR, lngR)];

  List<SubjectModel> get subjects => [
        SubjectModel(
          day: day,
          title: restId,
          address: addressS,
          deliveryTime: startTime,
          time: (timeS != null) ? timeS : 'Ordine non accettato',
        ),
        SubjectModel(
            day: day,
            title: nominative,
            address: addressR,
            time: timeR,
            deliveryTime: endTime,
            position: LatLngModel(lat: latR, lng: lngR))
      ];

  static DriverOrderModel fromJson(Map json) =>
      _$DriverOrderModelFromJson(json);

  static DriverOrderModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$DriverOrderModelToJson(this);

  @required
  String toString() => toJson().toString();
}
