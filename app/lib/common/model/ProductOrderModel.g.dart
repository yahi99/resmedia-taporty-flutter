// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductOrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductOrderModel _$ProductOrderModelFromJson(Map json) {
  return ProductOrderModel(
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    quantity: json['quantity'] as int,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$ProductOrderModelToJson(ProductOrderModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'imageUrl': instance.imageUrl,
      'quantity': instance.quantity,
    };
