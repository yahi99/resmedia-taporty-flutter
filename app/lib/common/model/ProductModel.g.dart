// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map json) {
  return ProductModel(
    path: json['path'] as String,
    name: json['name'] as String,
    price: (json['price'] as num)?.toDouble(),
    maxQuantity: json['maxQuantity'] as int,
    type: json['type'] as String,
    category: categoryFromJson(json['category'] as String),
    restaurantId: json['restaurantId'] as String,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('name', instance.name);
  writeNotNull('price', instance.price);
  writeNotNull('imageUrl', instance.imageUrl);
  writeNotNull('maxQuantity', instance.maxQuantity);
  writeNotNull('type', instance.type);
  writeNotNull('category', categoryToJson(instance.category));
  writeNotNull('restaurantId', instance.restaurantId);
  return val;
}
