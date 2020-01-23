// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'StripeSourceModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StripeSourceModel _$StripeSourceModelFromJson(Map json) {
  return StripeSourceModel(
    id: json['id'] as String,
    token: json['token'] as String,
    card: json['card'] == null
        ? null
        : StripeCardModel.fromJson(json['card'] as Map),
    lastUse: json['lastUse'] == null
        ? null
        : DateTime.parse(json['lastUse'] as String),
  );
}

Map<String, dynamic> _$StripeSourceModelToJson(StripeSourceModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('token', instance.token);
  writeNotNull('lastUse', instance.lastUse?.toIso8601String());
  writeNotNull('card', instance.card?.toJson());
  return val;
}

StripeCardModel _$StripeCardModelFromJson(Map json) {
  return StripeCardModel(
    StripeCardModel.brandFromJson(json['brand'] as String),
    json['fingerprint'] as String,
    json['last4'] as String,
    json['expMonth'] as int,
    json['expYear'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$StripeCardModelToJson(StripeCardModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('brand', StripeCardModel.brandToJson(instance.brand));
  writeNotNull('fingerprint', instance.fingerprint);
  writeNotNull('last4', instance.last4);
  writeNotNull('expMonth', instance.expMonth);
  writeNotNull('expYear', instance.expYear);
  writeNotNull('name', instance.name);
  return val;
}
