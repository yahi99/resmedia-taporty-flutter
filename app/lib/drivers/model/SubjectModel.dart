import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';

// TODO: Cerca di capire a cosa servono gli attributi
class SubjectModel {
  final String name, address, time;
  final LatLng position;
  final String day;
  final String displayName;

  SubjectModel({
    @required this.day,
    @required this.name,
    @required this.address,
    @required this.time,
    this.displayName,
    this.position,
  });
}
