// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TimeslotModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TimeslotModel _$TimeslotModelFromJson(Map json) {
  return TimeslotModel(
    start: TimeslotModel.timeFromJson(json['start'] as String),
    end: TimeslotModel.timeFromJson(json['end'] as String),
  );
}

Map<String, dynamic> _$TimeslotModelToJson(TimeslotModel instance) =>
    <String, dynamic>{
      'start': TimeslotModel.timeToJson(instance.start),
      'end': TimeslotModel.timeToJson(instance.end),
    };
