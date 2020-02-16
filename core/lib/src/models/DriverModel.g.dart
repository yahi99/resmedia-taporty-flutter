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
    reviewCount: json['reviewCount'] as int,
    rating: (json['rating'] as num)?.toDouble(),
    nominative: json['nominative'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    geohashPoint: json['geohashPoint'] == null
        ? null
        : GeohashPointModel.fromJson(json['geohashPoint'] as Map),
    address: json['address'] as String,
    stripeAccountId: json['stripeAccountId'] as String,
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
  writeNotNull('reviewCount', instance.reviewCount);
  writeNotNull('rating', instance.rating);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('geohashPoint', instance.geohashPoint?.toJson());
  writeNotNull('address', instance.address);
  writeNotNull('stripeAccountId', instance.stripeAccountId);
  return val;
}
