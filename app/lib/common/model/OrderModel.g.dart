// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantOrderModel _$RestaurantOrderModelFromJson(Map json) {
  return RestaurantOrderModel(
    path: json['path'] as String,
    timeLeft: json['timeLeft'] as int,
    restaurantId: json['restaurantId'] as String,
    isPaid: json['isPaid'] as bool,
    isReviewed: json['isReviewed'] as bool,
    phone: json['phone'] as String,
    day: json['day'] as String,
    fingerprint: json['fingerprint'] as String,
    addressR: json['addressR'] as String,
    endTime: json['endTime'] as String,
    products: (json['products'] as List)
        ?.map((e) => e == null ? null : ProductCart.fromJson(e as Map))
        ?.toList(),
    driver: json['driver'] as String,
    uid: json['uid'] as String,
    timeR: json['timeR'] as String,
    timeS: json['timeS'] as String,
    state: _$enumDecodeNullable(_$StateCategoryEnumMap, json['state']),
    startTime: json['startTime'] as String,
    nominative: json['nominative'] as String,
  );
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
  writeNotNull('timeR', instance.timeR);
  writeNotNull('timeS', instance.timeS);
  writeNotNull('state', _$StateCategoryEnumMap[instance.state]);
  writeNotNull('startTime', instance.startTime);
  writeNotNull('endTime', instance.endTime);
  writeNotNull('driver', instance.driver);
  writeNotNull('uid', instance.uid);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('addressR', instance.addressR);
  writeNotNull('fingerprint', instance.fingerprint);
  writeNotNull('day', instance.day);
  writeNotNull('phone', instance.phone);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('isPaid', instance.isPaid);
  writeNotNull('isReviewed', instance.isReviewed);
  writeNotNull('timeLeft', instance.timeLeft);
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

const _$StateCategoryEnumMap = {
  StateCategory.PENDING: 'PENDING',
  StateCategory.ACCEPTED: 'ACCEPTED',
  StateCategory.DELIVERED: 'DELIVERED',
  StateCategory.DENIED: 'DENIED',
  StateCategory.PICKED_UP: 'PICKED_UP',
  StateCategory.CANCELLED: 'CANCELLED',
};

UserOrderModel _$UserOrderModelFromJson(Map json) {
  return UserOrderModel(
    path: json['path'] as String,
    restaurantId: json['restaurantId'] as String,
    driver: json['driver'] as String,
    timeLeft: json['timeLeft'] as int,
    isReviewed: json['isReviewed'] as bool,
    uid: json['uid'] as String,
    phone: json['phone'] as String,
    day: json['day'] as String,
    endTime: json['endTime'] as String,
    products: (json['products'] as List)
        ?.map((e) => e == null ? null : ProductCart.fromJson(e as Map))
        ?.toList(),
    timeR: json['timeR'] as String,
    timeS: json['timeS'] as String,
    state: _$enumDecodeNullable(_$StateCategoryEnumMap, json['state']),
  );
}

Map<String, dynamic> _$UserOrderModelToJson(UserOrderModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull(
      'products', instance.products?.map((e) => e?.toJson())?.toList());
  writeNotNull('timeR', instance.timeR);
  writeNotNull('timeS', instance.timeS);
  writeNotNull('state', _$StateCategoryEnumMap[instance.state]);
  writeNotNull('endTime', instance.endTime);
  writeNotNull('day', instance.day);
  writeNotNull('phone', instance.phone);
  writeNotNull('isReviewed', instance.isReviewed);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('driver', instance.driver);
  writeNotNull('uid', instance.uid);
  writeNotNull('timeLeft', instance.timeLeft);
  return val;
}
