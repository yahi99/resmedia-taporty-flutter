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
    notifyEmail: json['notifyEmail'] as bool,
    notifySms: json['notifySms'] as bool,
    offersApp: json['offersApp'] as bool,
    offersEmail: json['offersEmail'] as bool,
    offersSms: json['offersSms'] as bool,
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
  writeNotNull('notifyEmail', instance.notifyEmail);
  writeNotNull('notifySms', instance.notifySms);
  writeNotNull('notifyApp', instance.notifyApp);
  writeNotNull('offersEmail', instance.offersEmail);
  writeNotNull('offersSms', instance.offersSms);
  writeNotNull('offersApp', instance.offersApp);
  return val;
}
