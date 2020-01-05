// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TurnModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TurnModel _$TurnModelFromJson(Map json) {
  return TurnModel(
    path: json['path'] as String,
    restaurantId: json['restaurantId'] as String,
    driver: json['driver'] as String,
    oid: json['oid'] as String,
    year: json['year'] as int,
    startTime: json['startTime'] as String,
    month: _$enumDecodeNullable(_$MonthCategoryEnumMap, json['month']),
    day: json['day'] as String,
    endTime: json['endTime'] as String,
  );
}

Map<String, dynamic> _$TurnModelToJson(TurnModel instance) {
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
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('month', _$MonthCategoryEnumMap[instance.month]);
  writeNotNull('driver', instance.driver);
  writeNotNull('oid', instance.oid);
  writeNotNull('year', instance.year);
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$MonthCategoryEnumMap = {
  MonthCategory.JANUARY: 'JANUARY',
  MonthCategory.FEBRUARY: 'FEBRUARY',
  MonthCategory.MARCH: 'MARCH',
  MonthCategory.APRIL: 'APRIL',
  MonthCategory.MAY: 'MAY',
  MonthCategory.JUNE: 'JUNE',
  MonthCategory.JULY: 'JULY',
  MonthCategory.AUGUST: 'AUGUST',
  MonthCategory.SEPTEMBER: 'SEPTEMBER',
  MonthCategory.OCTOBER: 'OCTOBER',
  MonthCategory.NOVEMBER: 'NOVEMBER',
  MonthCategory.DECEMBER: 'DECEMBER',
};
