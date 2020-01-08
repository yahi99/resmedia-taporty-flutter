import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/helper/GeopointSerialization.dart';
import 'package:resmedia_taporty_flutter/common/model/HolidayModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/model/TimetableModel.dart';

part 'RestaurantModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class RestaurantModel extends FirebaseModel {
  final String name;
  final String description;
  final String imageUrl;
  final String phoneNumber;

  @JsonKey(fromJson: geopointFromJson, toJson: geopointToJson)
  final GeoPoint coordinates;
  final String address;
  final double deliveryRadius;

  final List<HolidayModel> holidays;
  final Map<int, TimetableModel> weekdayTimetable;

  final int numberOfReviews;
  final double averageReviews;

  final bool isDisabled;

  bool isHoliday({DateTime datetime}) {
    if (datetime == null) datetime = DateTime.now();
    for (HolidayModel h in holidays) {
      if ((h.start.month < datetime.month || (h.start.month == datetime.month && h.start.day <= datetime.day)) &&
          (h.end.month > datetime.month || (h.end.month == datetime.month && h.end.day >= datetime.day))) return true;

      if ((h.start.month < datetime.month || (h.start.month == datetime.month && h.start.day <= datetime.day)) && h.start.isAfter(h.end)) return true;

      if ((h.end.month > datetime.month || (h.end.month == datetime.month && h.end.day >= datetime.day)) && h.start.isAfter(h.end)) return true;
    }
    return false;
  }

  bool isOpen({DateTime datetime}) {
    if (datetime == null) datetime = DateTime.now();

    if (isHoliday(datetime: datetime)) return false;

    var timetable = weekdayTimetable[datetime.weekday];

    if (!timetable.open) return false;

    var time = DateFormat("H:m:s").parse(datetime.hour.toString() + ":" + datetime.minute.toString() + ":" + datetime.second.toString());

    for (var timeslot in timetable.timeslots) {
      if (timeslot.start.isBefore(time) && timeslot.end.isAfter(time)) {
        return true;
      }
    }

    return false;
  }

  List<ShiftModel> getShifts(DateTime day) {
    List<ShiftModel> shifts = new List<ShiftModel>();
    if (isOpen(datetime: day)) return shifts;

    for (var timeslot in weekdayTimetable[day.weekday].timeslots) {
      var currentShift = timeslot.start.add(Duration(milliseconds: day.millisecondsSinceEpoch));
      var end = timeslot.end.add(Duration(milliseconds: day.millisecondsSinceEpoch));
      while (currentShift != end) {
        shifts.add(ShiftModel(startTime: DateTime.parse(currentShift.toIso8601String()), endTime: DateTime.parse((currentShift = currentShift.add(Duration(minutes: 15))).toIso8601String())));
      }
    }

    return shifts;
  }

  String getTimetableString({DateTime datetime}) {
    if (datetime == null) datetime = DateTime.now();
    var timetable = weekdayTimetable[datetime.weekday];

    var result = "";
    if (isOpen(datetime: datetime)) {
      bool first = true;
      for (var timeslot in timetable.timeslots) {
        if (!first) {
          result += "\n";
        }
        result += DateFormat("HH:mm").format(timeslot.start) + " - " + DateFormat("HH:mm").format(timeslot.end);
        first = false;
      }
      return result;
    } else
      return "Chiuso";
  }

  RestaurantModel({
    @required String path,
    @required this.name,
    @required this.description,
    @required this.coordinates,
    @required this.deliveryRadius,
    @required this.holidays,
    @required this.weekdayTimetable,
    this.address,
    this.phoneNumber,
    this.averageReviews,
    this.numberOfReviews,
    this.isDisabled,
    @required this.imageUrl,
  }) : super(path);

  LatLng getPos() {
    return (coordinates != null) ? LatLng(coordinates.latitude, coordinates.longitude) : null;
  }

  static RestaurantModel fromJson(Map json) => _$RestaurantModelFromJson(json);

  static RestaurantModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$RestaurantModelToJson(this);
}
