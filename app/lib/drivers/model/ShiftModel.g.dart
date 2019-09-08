// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map json) {
  return ShiftModel(
      path: json['path'] as String,
      users: (json['users'] as List)?.map((e) => e as String)?.toList(),
      startTime: json['startTime'] as String);
}

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('users', instance.users);
  writeNotNull('startTime', instance.startTime);
  return val;
}
