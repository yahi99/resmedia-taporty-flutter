// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GeohashPointModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GeohashPointModel _$GeohashPointModelFromJson(Map json) {
  return GeohashPointModel(
    json['geohash'] as String,
    geopointFromJson(json['geopoint']),
  );
}

Map<String, dynamic> _$GeohashPointModelToJson(GeohashPointModel instance) =>
    <String, dynamic>{
      'geohash': instance.geohash,
      'geopoint': geopointToJson(instance.geopoint),
    };
