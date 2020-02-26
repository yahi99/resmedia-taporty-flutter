// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map json) {
  return ShiftModel(
    path: json['path'] as String,
    endTime: datetimeFromTimestamp(json['endTime'] as Timestamp),
    startTime: datetimeFromTimestamp(json['startTime'] as Timestamp),
    driverId: json['driverId'] as String,
    geohashPoint: json['geohashPoint'] == null
        ? null
        : GeohashPointModel.fromJson(json['geohashPoint'] as Map),
    occupied: json['occupied'] as bool,
    rating: (json['rating'] as num)?.toDouble() ?? 0,
  );
}

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('startTime', datetimeToTimestamp(instance.startTime));
  writeNotNull('endTime', datetimeToTimestamp(instance.endTime));
  writeNotNull('driverId', instance.driverId);
  writeNotNull('geohashPoint', instance.geohashPoint?.toJson());
  writeNotNull('occupied', instance.occupied);
  writeNotNull('rating', instance.rating);
  return val;
}
