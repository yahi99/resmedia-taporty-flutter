// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CalendarModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CalendarModel _$CalendarModelFromJson(Map json) {
  return CalendarModel(
      path: json['path'] as String,
      number: json['number'] as int,
      isEmpty: json['isEmpty'] as bool,
      startTime: json['startTime'] as String,
      day: json['day'] as String,
      endTime: json['endTime'] as String,
      free: (json['free'] as List)?.map((e) => e as String)?.toList(),
      occupied: (json['occupied'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$CalendarModelToJson(CalendarModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('startTime', instance.startTime);
  writeNotNull('endTime', instance.endTime);
  writeNotNull('day', instance.day);
  writeNotNull('free', instance.free);
  writeNotNull('occupied', instance.occupied);
  writeNotNull('isEmpty', instance.isEmpty);
  writeNotNull('number', instance.number);
  return val;
}
