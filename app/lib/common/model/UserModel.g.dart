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
    isDriver: json['isDriver'] as bool,
    restaurantId: json['restaurantId'] as String,
    nominative: json['nominative'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    notifyApp: json['notifyApp'] as bool,
    notifyEmail: json['notifyEmail'] as bool,
    notifySms: json['notifySms'] as bool,
    offersApp: json['offersApp'] as bool,
    offersEmail: json['offersEmail'] as bool,
    offersSms: json['offersSms'] as bool,
    coordinates: geopointFromJson(json['coordinates']),
    address: json['address'] as String,
    deliveryRadius: (json['deliveryRadius'] as num)?.toDouble(),
  );
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
  writeNotNull('averageReviews', instance.averageReviews);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('img', instance.img);
  writeNotNull('notifyEmail', instance.notifyEmail);
  writeNotNull('notifySms', instance.notifySms);
  writeNotNull('notifyApp', instance.notifyApp);
  writeNotNull('offersEmail', instance.offersEmail);
  writeNotNull('offersSms', instance.offersSms);
  writeNotNull('offersApp', instance.offersApp);
  writeNotNull('isDriver', instance.isDriver);
  writeNotNull('type', instance.type);
  writeNotNull('coordinates', geopointToJson(instance.coordinates));
  writeNotNull('address', instance.address);
  writeNotNull('deliveryRadius', instance.deliveryRadius);
  return val;
}
