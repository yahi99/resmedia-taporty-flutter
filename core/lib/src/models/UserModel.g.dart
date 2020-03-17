// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map json) {
  return UserModel(
    path: json['path'] as String,
    fcmToken: json['fcmToken'] as String,
    imageUrl: json['imageUrl'] as String,
    nominative: json['nominative'] as String,
    email: json['email'] as String,
    phoneNumber: json['phoneNumber'] as String,
    notifyApp: json['notifyApp'] as bool,
    lastLocation: json['lastLocation'] == null
        ? null
        : LocationModel.fromJson(json['lastLocation'] as Map),
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
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('notifyApp', instance.notifyApp);
  writeNotNull('lastLocation', instance.lastLocation?.toJson());
  return val;
}
