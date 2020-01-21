// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimetableModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimetableModel _$TimetableModelFromJson(Map json) {
  return TimetableModel(
    open: json['open'] as bool,
    timeslotCount: json['timeslotCount'] as int,
    timeslots: (json['timeslots'] as List)
        ?.map((e) => e == null ? null : TimeslotModel.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$TimetableModelToJson(TimetableModel instance) =>
    <String, dynamic>{
      'open': instance.open,
      'timeslotCount': instance.timeslotCount,
      'timeslots': instance.timeslots?.map((e) => e?.toJson())?.toList(),
    };
