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
    type: json['type'] as String,
    category: _$enumDecodeNullable(_$ProductCategoryEnumMap, json['category']),
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
  val['type'] = instance.type;
  val['category'] = _$ProductCategoryEnumMap[instance.category];
  val['supplierId'] = instance.supplierId;
  return val;
}

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$ProductCategoryEnumMap = {
  ProductCategory.APPETIZER: 'APPETIZER',
  ProductCategory.FIRST_COURSES: 'FIRST_COURSES',
  ProductCategory.MAIN_COURSES: 'MAIN_COURSES',
  ProductCategory.SEAFOOD_MENU: 'SEAFOOD_MENU',
  ProductCategory.MEAT_MENU: 'MEAT_MENU',
  ProductCategory.SIDE_DISH: 'SIDE_DISH',
  ProductCategory.DESERT: 'DESERT',
  ProductCategory.DRINK: 'DRINK',
  ProductCategory.WINE: 'WINE',
  ProductCategory.ALCOHOLIC: 'ALCOHOLIC',
  ProductCategory.COFFEE: 'COFFEE',
};
