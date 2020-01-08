// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map json) {
  return OrderModel(
    path: json['path'] as String,
    productCount: json['productCount'] as int,
    totalPrice: (json['totalPrice'] as num)?.toDouble(),
    newProductCount: json['newProductCount'] as int,
    newTotalPrice: (json['newTotalPrice'] as num)?.toDouble(),
    preferredDeliveryTimestamp:
        datetimeFromJson(json['preferredDeliveryTimestamp']),
    modificationTimestamp: datetimeFromJson(json['modificationTimestamp']),
    cancellationTimestamp: datetimeFromJson(json['cancellationTimestamp']),
    readyTimestamp: datetimeFromJson(json['readyTimestamp']),
    pickupTimestamp: datetimeFromJson(json['pickupTimestamp']),
    deliveryTimestamp: datetimeFromJson(json['deliveryTimestamp']),
    customerName: json['customerName'] as String,
    customerCoordinates: geopointFromJson(json['customerCoordinates']),
    customerAddress: json['customerAddress'] as String,
    customerPhoneNumber: json['customerPhoneNumber'] as String,
    customerImageUrl: json['customerImageUrl'] as String,
    restaurantName: json['restaurantName'] as String,
    restaurantCoordinates: geopointFromJson(json['restaurantCoordinates']),
    restaurantAddress: json['restaurantAddress'] as String,
    restaurantPhoneNumber: json['restaurantPhoneNumber'] as String,
    restaurantImageUrl: json['restaurantImageUrl'] as String,
    driverName: json['driverName'] as String,
    driverPhoneNumber: json['driverPhoneNumber'] as String,
    driverImageUrl: json['driverImageUrl'] as String,
    restaurantId: json['restaurantId'] as String,
    driverId: json['driverId'] as String,
    isReviewed: json['isReviewed'] as bool,
    customerId: json['customerId'] as String,
    products: json['products'] as List,
    creationTimestamp: datetimeFromJson(json['creationTimestamp']),
    acceptanceTimestamp: datetimeFromJson(json['acceptanceTimestamp']),
    state: _$enumDecodeNullable(_$OrderStateEnumMap, json['state']),
    cardId: json['cardId'] as String,
  );
}

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('products', instance.products);
  writeNotNull('productCount', instance.productCount);
  writeNotNull('totalPrice', instance.totalPrice);
  writeNotNull('newProductCount', instance.newProductCount);
  writeNotNull('newTotalPrice', instance.newTotalPrice);
  writeNotNull('state', _$OrderStateEnumMap[instance.state]);
  writeNotNull('isReviewed', instance.isReviewed);
  writeNotNull('creationTimestamp', datetimeToJson(instance.creationTimestamp));
  writeNotNull(
      'acceptanceTimestamp', datetimeToJson(instance.acceptanceTimestamp));
  writeNotNull('preferredDeliveryTimestamp',
      datetimeToJson(instance.preferredDeliveryTimestamp));
  writeNotNull(
      'modificationTimestamp', datetimeToJson(instance.modificationTimestamp));
  writeNotNull(
      'cancellationTimestamp', datetimeToJson(instance.cancellationTimestamp));
  writeNotNull('readyTimestamp', datetimeToJson(instance.readyTimestamp));
  writeNotNull('pickupTimestamp', datetimeToJson(instance.pickupTimestamp));
  writeNotNull('deliveryTimestamp', datetimeToJson(instance.deliveryTimestamp));
  writeNotNull('customerId', instance.customerId);
  writeNotNull('customerName', instance.customerName);
  writeNotNull(
      'customerCoordinates', geopointToJson(instance.customerCoordinates));
  writeNotNull('customerAddress', instance.customerAddress);
  writeNotNull('customerPhoneNumber', instance.customerPhoneNumber);
  writeNotNull('customerImageUrl', instance.customerImageUrl);
  writeNotNull('cardId', instance.cardId);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('restaurantName', instance.restaurantName);
  writeNotNull(
      'restaurantCoordinates', geopointToJson(instance.restaurantCoordinates));
  writeNotNull('restaurantAddress', instance.restaurantAddress);
  writeNotNull('restaurantPhoneNumber', instance.restaurantPhoneNumber);
  writeNotNull('restaurantImageUrl', instance.restaurantImageUrl);
  writeNotNull('driverId', instance.driverId);
  writeNotNull('driverName', instance.driverName);
  writeNotNull('driverPhoneNumber', instance.driverPhoneNumber);
  writeNotNull('driverImageUrl', instance.driverImageUrl);
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

const _$OrderStateEnumMap = {
  OrderState.NEW: 'NEW',
  OrderState.ACCEPTED: 'ACCEPTED',
  OrderState.MODIFIED: 'MODIFIED',
  OrderState.CANCELLED: 'CANCELLED',
  OrderState.READY: 'READY',
  OrderState.PICKED_UP: 'PICKED_UP',
  OrderState.DELIVERED: 'DELIVERED',
  OrderState.ARCHIVED: 'ARCHIVED',
  OrderState.REFUSED: 'REFUSED',
};
