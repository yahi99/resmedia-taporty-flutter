// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StripeLinkCreationResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeLinkCreationResult _$StripeLinkCreationResultFromJson(Map json) {
  return StripeLinkCreationResult(
    json['success'] as bool,
    json['error'] as String,
    json['link'] as String,
  );
}

Map<String, dynamic> _$StripeLinkCreationResultToJson(
    StripeLinkCreationResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('error', instance.error);
  writeNotNull('link', instance.link);
  return val;
}
