// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantOrderModel _$RestaurantOrderModelFromJson(Map json) {
  return RestaurantOrderModel(
      path: json['path'] as String,
      products: (json['products'] as List)
          ?.map((e) => e == null ? null : ProductCart.fromJson(e as Map))
          ?.toList(),
      time: json['time'] as String,
      state: _$enumDecodeNullable(_$StateCategoryEnumMap, json['state']));
}

Map<String, dynamic> _$RestaurantOrderModelToJson(
    RestaurantOrderModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull(
      'products', instance.products?.map((e) => e?.toJson())?.toList());
  writeNotNull('time', instance.time);
  writeNotNull('state', _$StateCategoryEnumMap[instance.state]);
  return val;
}

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$StateCategoryEnumMap = <StateCategory, dynamic>{
  StateCategory.PENDING: 'PENDING',
  StateCategory.ACCEPTED: 'ACCEPTED',
  StateCategory.DONE: 'DONE'
};
