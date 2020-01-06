// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'CartModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartModel _$CartModelFromJson(Map json) {
  return CartModel(
    products: (json['products'] as List)
        ?.map((e) => e == null ? null : ProductCartModel.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$CartModelToJson(CartModel instance) => <String, dynamic>{
      'products': instance.products?.map((e) => e?.toJson())?.toList(),
    };
