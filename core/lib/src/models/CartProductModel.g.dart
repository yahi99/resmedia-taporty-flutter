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
    supplierId: json['supplierId'] as String,
    userId: json['userId'] as String,
    price: (json['price'] as num)?.toDouble(),
    delete: json['delete'] as bool,
  );
}

Map<String, dynamic> _$CartProductModelToJson(CartProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'supplierId': instance.supplierId,
      'quantity': instance.quantity,
      'price': instance.price,
      'type': instance.type,
      'delete': instance.delete,
    };
