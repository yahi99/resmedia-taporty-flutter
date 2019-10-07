// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'NotificationModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModelFirebase _$NotificationModelFirebaseFromJson(Map json) {
  return NotificationModelFirebase(
    notification: json['notification'] == null
        ? null
        : NotificationMessageModelFirebase.fromJson(
            json['notification'] as Map),
  );
}

Map<String, dynamic> _$NotificationModelFirebaseToJson(
    NotificationModelFirebase instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('notification', instance.notification?.toJson());
  return val;
}

NotificationMessageModelFirebase _$NotificationMessageModelFirebaseFromJson(
    Map json) {
  return NotificationMessageModelFirebase(
    tag: json['tag'] as String,
    body: json['body'] as String,
    icon: json['icon'] as String,
    badge: json['badge'] as String,
    color: json['color'] as String,
    sound: json['sound'] as String,
    title: json['title'] as String,
    bodyLocKey: json['bodyLocKey'] as String,
    bodyLocArgs: json['bodyLocArgs'] as String,
    clickAction: json['clickAction'] as String,
    titleLocKey: json['titleLocKey'] as String,
    titleLocArgs: json['titleLocArgs'] as String,
  );
}

Map<String, dynamic> _$NotificationMessageModelFirebaseToJson(
    NotificationMessageModelFirebase instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('tag', instance.tag);
  writeNotNull('body', instance.body);
  writeNotNull('icon', instance.icon);
  writeNotNull('badge', instance.badge);
  writeNotNull('color', instance.color);
  writeNotNull('sound', instance.sound);
  writeNotNull('title', instance.title);
  writeNotNull('bodyLocKey', instance.bodyLocKey);
  writeNotNull('bodyLocArgs', instance.bodyLocArgs);
  writeNotNull('clickAction', instance.clickAction);
  writeNotNull('titleLocKey', instance.titleLocKey);
  writeNotNull('titleLocArgs', instance.titleLocArgs);
  return val;
}
