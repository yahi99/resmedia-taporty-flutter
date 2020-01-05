// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HolidayModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HolidayModel _$HolidayModelFromJson(Map json) {
  return HolidayModel(
    name: json['name'] as String,
    start: HolidayModel.dateFromJson(json['start'] as String),
    end: HolidayModel.dateFromJson(json['end'] as String),
  );
}

Map<String, dynamic> _$HolidayModelToJson(HolidayModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'start': HolidayModel.dateToJson(instance.start),
      'end': HolidayModel.dateToJson(instance.end),
    };
