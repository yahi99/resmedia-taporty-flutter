// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderProductModel _$OrderProductModelFromJson(Map json) {
  return OrderProductModel(
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    quantity: json['quantity'] as int,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$OrderProductModelToJson(OrderProductModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'quantity': instance.quantity,
    };
