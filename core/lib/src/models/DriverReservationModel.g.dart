// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverReservationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverReservationModel _$DriverReservationModelFromJson(Map json) {
  return DriverReservationModel(
    json['driverId'] as String,
    json['available'] as bool,
    geopointFromJson(json['geopoint']),
    (json['rating'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DriverReservationModelToJson(
        DriverReservationModel instance) =>
    <String, dynamic>{
      'driverId': instance.driverId,
      'available': instance.available,
      'geopoint': geopointToJson(instance.geopoint),
      'rating': instance.rating,
    };
