// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductRequestModel _$ProductRequestModelFromJson(Map json) {
  return ProductRequestModel(
    path: json['path'] as String,
    cat: json['cat'] as String,
    category: json['category'] as String,
    img: json['img'] as String,
    price: json['price'] as String,
    title: json['title'] as String,
    quantity: json['quantity'] as String,
    restaurantId: json['restaurantId'] as String,
  );
}

Map<String, dynamic> _$ProductRequestModelToJson(ProductRequestModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('cat', instance.cat);
  writeNotNull('category', instance.category);
  writeNotNull('img', instance.img);
  writeNotNull('price', instance.price);
  writeNotNull('quantity', instance.quantity);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('title', instance.title);
  return val;
}
