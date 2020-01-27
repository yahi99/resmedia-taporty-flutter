// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'DriverModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverModel _$DriverModelFromJson(Map json) {
  return DriverModel(
    path: json['path'] as String,
    fcmToken: json['fcmToken'] as String,
    imageUrl: json['imageUrl'] as String,
    numberOfReviews: json['numberOfReviews'] as int,
    averageReviews: (json['averageReviews'] as num)?.toDouble(),
    nominative: json['nominative'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    coordinates: geopointFromJson(json['coordinates']),
    address: json['address'] as String,
    deliveryRadius: (json['deliveryRadius'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DriverModelToJson(DriverModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('fcmToken', instance.fcmToken);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('email', instance.email);
  writeNotNull('phoneNumber', instance.phoneNumber);
  writeNotNull('numberOfReviews', instance.numberOfReviews);
  writeNotNull('averageReviews', instance.averageReviews);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('coordinates', geopointToJson(instance.coordinates));
  writeNotNull('address', instance.address);
  writeNotNull('deliveryRadius', instance.deliveryRadius);
  return val;
}
