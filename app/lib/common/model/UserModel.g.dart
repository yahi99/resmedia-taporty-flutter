// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map json) {
  return UserModel(
      path: json['path'] as String,
      fcmToken: json['fcmToken'] as String,
      img: json['img'] as String,
      numberOfReviews: json['numberOfReviews'] as int,
      averageReviews: (json['averageReviews'] as num)?.toDouble(),
      type: json['type'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      lng: (json['lng'] as num)?.toDouble(),
      isDriver: json['isDriver'] as bool,
      restaurantId: json['restaurantId'] as String,
      nominative: json['nominative'] as String,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as int,
      notifyApp: json['notifyApp'] as bool,
      notifyEmail: json['notifyEmail'] as bool,
      notifySms: json['notifySms'] as bool,
      offersApp: json['offersApp'] as bool,
      offersEmail: json['offersEmail'] as bool,
      offersSms: json['offersSms'] as bool);
}

Map<String, dynamic> _$UserModelToJson(UserModel instance) {
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
  val['averageReviews'] = instance.averageReviews;
  val['restaurantId'] = instance.restaurantId;
  val['img'] = instance.img;
  val['notifyEmail'] = instance.notifyEmail;
  val['notifySms'] = instance.notifySms;
  val['notifyApp'] = instance.notifyApp;
  val['offersEmail'] = instance.offersEmail;
  val['offersSms'] = instance.offersSms;
  val['offersApp'] = instance.offersApp;
  val['lat'] = instance.lat;
  val['lng'] = instance.lng;
  val['isDriver'] = instance.isDriver;
  val['type'] = instance.type;
  return val;
}
