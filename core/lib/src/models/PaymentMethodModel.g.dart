// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PaymentMethodModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentMethodModel _$PaymentMethodModelFromJson(Map json) {
  return PaymentMethodModel(
    json['id'] as String,
    json['type'] as String,
    json['customerId'] as String,
    json['card'] == null ? null : CreditCardModel.fromJson(json['card'] as Map),
  );
}

Map<String, dynamic> _$PaymentMethodModelToJson(PaymentMethodModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('customerId', instance.customerId);
  writeNotNull('type', instance.type);
  writeNotNull('card', instance.card?.toJson());
  return val;
}

CreditCardModel _$CreditCardModelFromJson(Map json) {
  return CreditCardModel(
    json['brand'] as String,
    json['token'] as String,
    json['last4'] as String,
    json['expMonth'] as int,
    json['expYear'] as int,
    json['name'] as String,
  );
}

Map<String, dynamic> _$CreditCardModelToJson(CreditCardModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('brand', instance.brand);
  writeNotNull('token', instance.token);
  writeNotNull('last4', instance.last4);
  writeNotNull('expMonth', instance.expMonth);
  writeNotNull('expYear', instance.expYear);
  writeNotNull('name', instance.name);
  return val;
}
