import 'package:easy_blocs/easy_blocs.dart';
import 'package:json_annotation/json_annotation.dart';


part 'NotificationModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class NotificationModelFirebase extends JsonRule {
  final NotificationMessageModelFirebase notification;

  NotificationModelFirebase({this.notification});
  /// Map<String, dynamic> data

  static NotificationModelFirebase fromJson(Map json) => _$NotificationModelFirebaseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationModelFirebaseToJson(this);

  String toString() => 'FirebaseNotificationModel(notification: $notification)';
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class NotificationMessageModelFirebase extends JsonRule {
  final String tag, body, icon, badge, color, sound, title,
      bodyLocKey, bodyLocArgs, clickAction, titleLocKey, titleLocArgs;

  NotificationMessageModelFirebase({
    this.tag, this.body, this.icon, this.badge, this.color, this.sound, this.title,
    this.bodyLocKey, this.bodyLocArgs, this.clickAction, this.titleLocKey, this.titleLocArgs,
  });

  static NotificationMessageModelFirebase fromJson(Map json) => _$NotificationMessageModelFirebaseFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationMessageModelFirebaseToJson(this);

  String toString() => 'FirebaseNotificationMessageModel('
      'tag: $tag, body: $body, icon: $icon, badge: $badge, color: $color, sound: $sound, '
      'title: $title, bodyLocKey: $bodyLocKey, bodyLocArgs: $bodyLocArgs, '
      'clickAction: $clickAction, titleLocKey: $titleLocKey, titleLocArgs: $titleLocArgs, )';
}
