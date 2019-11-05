// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverRequestModel _$DriverRequestModelFromJson(Map json) {
  return DriverRequestModel(
      path: json['path'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      address: json['address'] as String,
      codiceFiscale: json['codiceFiscale'] as String,
      mezzo: json['mezzo'] as String,
      experience: json['experience'] as String,
      km: (json['km'] as num)?.toDouble(),
      nominative: json['nominative'] as String,
      lng: (json['lng'] as num)?.toDouble());
}

Map<String, dynamic> _$DriverRequestModelToJson(DriverRequestModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('codiceFiscale', instance.codiceFiscale);
  writeNotNull('address', instance.address);
  writeNotNull('mezzo', instance.mezzo);
  writeNotNull('experience', instance.experience);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('lat', instance.lat);
  writeNotNull('lng', instance.lng);
  writeNotNull('km', instance.km);
  return val;
}
