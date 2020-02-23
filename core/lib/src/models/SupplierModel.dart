import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/GeohashPointModel.dart';
import 'package:resmedia_taporty_core/src/models/ProductCategoryModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/src/models/HolidayModel.dart';
import 'package:resmedia_taporty_core/src/models/TimetableModel.dart';

part 'SupplierModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class SupplierModel extends FirebaseModel {
  final String name;
  final String description;
  final String imageUrl;
  final String phoneNumber;

  final String category;
  final List<String> tags;

  final GeohashPointModel geohashPoint;
  final String address;

  final List<HolidayModel> holidays;
  final Map<int, TimetableModel> weekdayTimetable;

  final int reviewCount;
  final double rating;

  final bool isDisabled;

  final List<ProductCategoryModel> categories;

  @JsonKey(ignore: true)
  Map<int, List<DateTime>> shiftStartTimes;

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
      // Nel caso si parli di orario continuato (timeslot che va da 00:00 a 00:00)
      if (timeslot.start.hour == 0 && timeslot.start.minute == 0 && timeslot.end.hour == 0 && timeslot.end.minute == 0) return true;
      if (timeslot.start.isBefore(time) && timeslot.end.isAfter(time)) {
        return true;
      }
    }

    return false;
  }

  // Restituisce gli inizi dei turni disponibili dal giorno "start" al giorno "end"
  List<DateTime> getShiftStartTimes(DateTime start, [DateTime end]) {
    List<DateTime> startTimes = List<DateTime>();
    start = DateTimeHelper.getDay(start);
    end = DateTimeHelper.getDay(end ?? start);
    for (DateTime current = start; current.isBefore(end) || current.isAtSameMomentAs(end); current = current.add(Duration(days: 1))) {
      if (!isHoliday(datetime: current)) {
        // Aggiunge tutti gli orari di inizio turno, sulla base del giorno che si sta analizzando
        startTimes.addAll(shiftStartTimes[current.weekday].map((s) => current.add(Duration(hours: s.hour, minutes: s.minute))));
      }
    }
    return startTimes;
  }

  String getTimetableString({DateTime datetime}) {
    if (datetime == null) datetime = DateTime.now();
    var timetable = weekdayTimetable[datetime.weekday];

    var result = "";
    if (!isHoliday(datetime: datetime) && weekdayTimetable[datetime.weekday].open) {
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

  SupplierModel({
    @required String path,
    @required this.name,
    @required this.description,
    @required this.geohashPoint,
    @required this.category,
    @required this.tags,
    @required this.holidays,
    @required this.weekdayTimetable,
    @required this.categories,
    this.address,
    this.phoneNumber,
    this.rating,
    this.reviewCount,
    this.isDisabled,
    @required this.imageUrl,
  }) : super(path) {
    shiftStartTimes = Map<int, List<DateTime>>();
    DateTime base = DateTimeHelper.baseDateTime();

    // Calcola in anticipo i turni disponibili per i 7 giorni della settimana
    for (var i = 1; i <= 7; i++) {
      shiftStartTimes[i] = List<DateTime>();
      if (weekdayTimetable[i].open) {
        for (var timeslot in weekdayTimetable[i].timeslots) {
          var currentDate = base.add(Duration(hours: timeslot.start.hour, minutes: timeslot.start.minute));
          var endDate = base.add(Duration(hours: timeslot.end.hour, minutes: timeslot.end.minute));
          // Nel caso si parli di orario continuato (timeslot che va da 00:00 a 00:00)
          if (currentDate.hour == 0 && currentDate.minute == 0 && endDate.hour == 0 && endDate.minute == 0) {
            endDate = currentDate.add(Duration(days: 1));
          }
          while (currentDate != endDate) {
            shiftStartTimes[i].add(DateTimeHelper.clone(currentDate));
            currentDate = currentDate.add(Duration(minutes: 15));
          }
        }
      }
    }
  }

  static SupplierModel fromJson(Map json) => _$SupplierModelFromJson(json);

  static SupplierModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$SupplierModelToJson(this);
}
