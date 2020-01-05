// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FoodModel _$FoodModelFromJson(Map json) {
  return FoodModel(
    path: json['path'] as String,
    img: json['img'] as String,
    isDisabled: json['isDisabled'] as bool,
    price: json['price'] as String,
    category: _$enumDecodeNullable(_$FoodCategoryEnumMap, json['category']),
    restaurantId: json['restaurantId'] as String,
    number: json['number'] as String,
  );
}

Map<String, dynamic> _$FoodModelToJson(FoodModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('price', instance.price);
  writeNotNull('img', instance.img);
  writeNotNull('category', _$FoodCategoryEnumMap[instance.category]);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('number', instance.number);
  writeNotNull('isDisabled', instance.isDisabled);
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

const _$FoodCategoryEnumMap = {
  FoodCategory.APPETIZER: 'APPETIZER',
  FoodCategory.FIRST_COURSES: 'FIRST_COURSES',
  FoodCategory.MAIN_COURSES: 'MAIN_COURSES',
  FoodCategory.SEAFOOD_MENU: 'SEAFOOD_MENU',
  FoodCategory.MEAT_MENU: 'MEAT_MENU',
  FoodCategory.SIDE_DISH: 'SIDE_DISH',
  FoodCategory.DESERT: 'DESERT',
  FoodCategory.DRINK: 'DRINK',
  FoodCategory.WINE: 'WINE',
  FoodCategory.ALCOHOLIC: 'ALCOHOLIC',
  FoodCategory.COFFEE: 'COFFEE',
};

DrinkModel _$DrinkModelFromJson(Map json) {
  return DrinkModel(
    path: json['path'] as String,
    category: _$enumDecodeNullable(_$DrinkCategoryEnumMap, json['category']),
    isDisabled: json['isDisabled'] as bool,
    img: json['img'] as String,
    price: json['price'] as String,
    restaurantId: json['restaurantId'] as String,
    number: json['number'] as String,
  );
}

Map<String, dynamic> _$DrinkModelToJson(DrinkModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('price', instance.price);
  writeNotNull('category', _$DrinkCategoryEnumMap[instance.category]);
  writeNotNull('img', instance.img);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('number', instance.number);
  writeNotNull('isDisabled', instance.isDisabled);
  return val;
}

const _$DrinkCategoryEnumMap = {
  DrinkCategory.DRINK: 'DRINK',
  DrinkCategory.WINE: 'WINE',
  DrinkCategory.ALCOHOLIC: 'ALCOHOLIC',
  DrinkCategory.COFFEE: 'COFFEE',
};