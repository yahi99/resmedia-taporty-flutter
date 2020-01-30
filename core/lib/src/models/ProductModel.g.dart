// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map json) {
  return ProductModel(
    path: json['path'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    price: (json['price'] as num)?.toDouble(),
    maxQuantity: json['maxQuantity'] as int,
    category: json['category'] as String,
    supplierId: json['supplierId'] as String,
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
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['price'] = instance.price;
  val['imageUrl'] = instance.imageUrl;
  val['maxQuantity'] = instance.maxQuantity;
  val['category'] = instance.category;
  val['supplierId'] = instance.supplierId;
  return val;
}
