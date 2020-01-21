// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map json) {
  return ShiftModel(
    path: json['path'] as String,
    endTime: datetimeFromJson(json['endTime']),
    startTime: datetimeFromJson(json['startTime']),
    driverId: json['driverId'] as String,
    deliveryRadius: (json['deliveryRadius'] as num)?.toDouble(),
    driverCoordinates: geopointFromJson(json['driverCoordinates']),
    occupied: json['occupied'] as bool,
    reservationTimestamp: datetimeFromJson(json['reservationTimestamp']),
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
  writeNotNull('startTime', datetimeToJson(instance.startTime));
  writeNotNull('endTime', datetimeToJson(instance.endTime));
  writeNotNull('driverId', instance.driverId);
  writeNotNull('deliveryRadius', instance.deliveryRadius);
  writeNotNull('driverCoordinates', geopointToJson(instance.driverCoordinates));
  writeNotNull('occupied', instance.occupied);
  writeNotNull(
      'reservationTimestamp', datetimeToJson(instance.reservationTimestamp));
  return val;
}
