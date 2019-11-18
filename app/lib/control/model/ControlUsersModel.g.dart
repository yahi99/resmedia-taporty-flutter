// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ControlUsersModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ControlUsersModel _$ControlUsersModelFromJson(Map json) {
  return ControlUsersModel(
      path: json['path'] as String,
      users: (json['users'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$ControlUsersModelToJson(ControlUsersModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('users', instance.users);
  return val;
}
