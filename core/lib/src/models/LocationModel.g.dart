// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'LocationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocationModel _$LocationModelFromJson(Map json) {
  return LocationModel(
    json['address'] as String,
    json['shortAddress'] as String,
    geopointFromJson(json['coordinates']),
  );
}

Map<String, dynamic> _$LocationModelToJson(LocationModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('coordinates', geopointToJson(instance.coordinates));
  writeNotNull('address', instance.address);
  writeNotNull('shortAddress', instance.shortAddress);
  return val;
}
