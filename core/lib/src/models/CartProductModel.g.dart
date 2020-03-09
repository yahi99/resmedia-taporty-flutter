// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartProductModel _$CartProductModelFromJson(Map json) {
  return CartProductModel(
    type: json['type'] as String,
    id: json['id'] as String,
    quantity: json['quantity'] as int,
    price: (json['price'] as num)?.toDouble(),
    notes: json['notes'] as String,
  );
}

Map<String, dynamic> _$CartProductModelToJson(CartProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'price': instance.price,
      'type': instance.type,
      'notes': instance.notes,
    };
