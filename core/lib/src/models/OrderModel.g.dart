// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map json) {
  return OrderModel(
    path: json['path'] as String,
    productCount: json['productCount'] as int,
    notes: json['notes'] as String,
    totalPrice: (json['totalPrice'] as num)?.toDouble(),
    newProductCount: json['newProductCount'] as int,
    newTotalPrice: (json['newTotalPrice'] as num)?.toDouble(),
    shiftStartTime: datetimeFromTimestamp(json['shiftStartTime'] as Timestamp),
    preferredDeliveryTimestamp:
        datetimeFromTimestamp(json['preferredDeliveryTimestamp'] as Timestamp),
    modificationTimestamp:
        datetimeFromTimestamp(json['modificationTimestamp'] as Timestamp),
    cancellationTimestamp:
        datetimeFromTimestamp(json['cancellationTimestamp'] as Timestamp),
    readyTimestamp: datetimeFromTimestamp(json['readyTimestamp'] as Timestamp),
    pickupTimestamp:
        datetimeFromTimestamp(json['pickupTimestamp'] as Timestamp),
    deliveryTimestamp:
        datetimeFromTimestamp(json['deliveryTimestamp'] as Timestamp),
    customerName: json['customerName'] as String,
    customerCoordinates: geopointFromJson(json['customerCoordinates']),
    customerAddress: json['customerAddress'] as String,
    customerPhoneNumber: json['customerPhoneNumber'] as String,
    customerImageUrl: json['customerImageUrl'] as String,
    supplierName: json['supplierName'] as String,
    supplierCoordinates: geopointFromJson(json['supplierCoordinates']),
    supplierAddress: json['supplierAddress'] as String,
    supplierPhoneNumber: json['supplierPhoneNumber'] as String,
    supplierImageUrl: json['supplierImageUrl'] as String,
    driverName: json['driverName'] as String,
    driverPhoneNumber: json['driverPhoneNumber'] as String,
    driverImageUrl: json['driverImageUrl'] as String,
    supplierId: json['supplierId'] as String,
    driverId: json['driverId'] as String,
    hasSupplierReview: json['hasSupplierReview'] as bool ?? false,
    hasDriverReview: json['hasDriverReview'] as bool ?? false,
    customerId: json['customerId'] as String,
    products: (json['products'] as List)
        ?.map((e) => e == null ? null : OrderProductModel.fromJson(e as Map))
        ?.toList(),
    newProducts: (json['newProducts'] as List)
        ?.map((e) => e == null ? null : OrderProductModel.fromJson(e as Map))
        ?.toList(),
    creationTimestamp:
        datetimeFromTimestamp(json['creationTimestamp'] as Timestamp),
    acceptanceTimestamp:
        datetimeFromTimestamp(json['acceptanceTimestamp'] as Timestamp),
    refusalTimestamp:
        datetimeFromTimestamp(json['refusalTimestamp'] as Timestamp),
    archiviationTimestamp:
        datetimeFromTimestamp(json['archiviationTimestamp'] as Timestamp),
    state: _$enumDecodeNullable(_$OrderStateEnumMap, json['state']),
    paymentIntentId: json['paymentIntentId'] as String,
    driverPickedUp: json['driverPickedUp'] as bool ?? false,
    supplierPickedUp: json['supplierPickedUp'] as bool ?? false,
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
  writeNotNull(
      'products', instance.products?.map((e) => e?.toJson())?.toList());
  writeNotNull(
      'newProducts', instance.newProducts?.map((e) => e?.toJson())?.toList());
  writeNotNull('productCount', instance.productCount);
  writeNotNull('totalPrice', instance.totalPrice);
  writeNotNull('newProductCount', instance.newProductCount);
  writeNotNull('newTotalPrice', instance.newTotalPrice);
  writeNotNull('notes', instance.notes);
  writeNotNull('state', _$OrderStateEnumMap[instance.state]);
  writeNotNull('hasSupplierReview', instance.hasSupplierReview);
  writeNotNull('hasDriverReview', instance.hasDriverReview);
  writeNotNull(
      'creationTimestamp', datetimeToTimestamp(instance.creationTimestamp));
  writeNotNull(
      'acceptanceTimestamp', datetimeToTimestamp(instance.acceptanceTimestamp));
  writeNotNull('shiftStartTime', datetimeToTimestamp(instance.shiftStartTime));
  writeNotNull('preferredDeliveryTimestamp',
      datetimeToTimestamp(instance.preferredDeliveryTimestamp));
  writeNotNull('modificationTimestamp',
      datetimeToTimestamp(instance.modificationTimestamp));
  writeNotNull('cancellationTimestamp',
      datetimeToTimestamp(instance.cancellationTimestamp));
  writeNotNull('readyTimestamp', datetimeToTimestamp(instance.readyTimestamp));
  writeNotNull(
      'pickupTimestamp', datetimeToTimestamp(instance.pickupTimestamp));
  writeNotNull(
      'deliveryTimestamp', datetimeToTimestamp(instance.deliveryTimestamp));
  writeNotNull(
      'refusalTimestamp', datetimeToTimestamp(instance.refusalTimestamp));
  writeNotNull('archiviationTimestamp',
      datetimeToTimestamp(instance.archiviationTimestamp));
  writeNotNull('customerId', instance.customerId);
  writeNotNull('customerName', instance.customerName);
  writeNotNull(
      'customerCoordinates', geopointToJson(instance.customerCoordinates));
  writeNotNull('customerAddress', instance.customerAddress);
  writeNotNull('customerPhoneNumber', instance.customerPhoneNumber);
  writeNotNull('customerImageUrl', instance.customerImageUrl);
  writeNotNull('paymentIntentId', instance.paymentIntentId);
  writeNotNull('supplierId', instance.supplierId);
  writeNotNull('supplierName', instance.supplierName);
  writeNotNull(
      'supplierCoordinates', geopointToJson(instance.supplierCoordinates));
  writeNotNull('supplierAddress', instance.supplierAddress);
  writeNotNull('supplierPhoneNumber', instance.supplierPhoneNumber);
  writeNotNull('supplierImageUrl', instance.supplierImageUrl);
  writeNotNull('driverId', instance.driverId);
  writeNotNull('driverName', instance.driverName);
  writeNotNull('driverPhoneNumber', instance.driverPhoneNumber);
  writeNotNull('driverImageUrl', instance.driverImageUrl);
  writeNotNull('driverPickedUp', instance.driverPickedUp);
  writeNotNull('supplierPickedUp', instance.supplierPickedUp);
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
