// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IntentCreationResult.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IntentCreationResult _$IntentCreationResultFromJson(Map json) {
  return IntentCreationResult(
    json['success'] as bool,
    json['error'] as String,
    json['paymentIntentId'] as String,
    json['clientSecret'] as String,
    json['paymentMethodId'] as String,
  );
}

Map<String, dynamic> _$IntentCreationResultToJson(
    IntentCreationResult instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('success', instance.success);
  writeNotNull('error', instance.error);
  writeNotNull('paymentIntentId', instance.paymentIntentId);
  writeNotNull('clientSecret', instance.clientSecret);
  writeNotNull('paymentMethodId', instance.paymentMethodId);
  return val;
}
