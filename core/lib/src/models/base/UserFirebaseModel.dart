import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';

abstract class UserFirebaseModel extends FirebaseModel {
  @JsonKey(includeIfNull: false)
  final String fcmToken;

  UserFirebaseModel({String path, this.fcmToken}) : super(path);
}
