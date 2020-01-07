// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverReservationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverReservationModel _$DriverReservationModelFromJson(Map json) {
  return DriverReservationModel(
    path: json['path'] as String,
    reserveTimestamp: datetimeFromJson(json['reserveTimestamp']),
    occupied: json['occupied'] as bool,
    driverCoordinates: geopointFromJson(json['driverCoordinates']),
    deliveryRadius: (json['deliveryRadius'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DriverReservationModelToJson(
    DriverReservationModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('reserveTimestamp', datetimeToJson(instance.reserveTimestamp));
  writeNotNull('occupied', instance.occupied);
  writeNotNull('driverCoordinates', geopointToJson(instance.driverCoordinates));
  writeNotNull('deliveryRadius', instance.deliveryRadius);
  return val;
}
