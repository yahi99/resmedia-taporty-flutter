import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_core/src/helper/GeopointSerialization.dart';
import 'package:resmedia_taporty_core/src/models/OrderProductModel.dart';

part 'OrderModel.g.dart';

enum OrderState { NEW, ACCEPTED, MODIFIED, CANCELLED, READY, PICKED_UP, DELIVERED, ARCHIVED, REFUSED }

String orderStateEncode(OrderState state) {
  return _$OrderStateEnumMap[state];
}

String translateOrderState(OrderState state) {
  switch (state) {
    case OrderState.PICKED_UP:
      return "In consegna";
    case OrderState.REFUSED:
      return "Ordine rifiutato";
    case OrderState.NEW:
      return "In accettazione";
    case OrderState.ACCEPTED:
      return "In preparazione";
    case OrderState.DELIVERED:
      return "Consegnato";
    case OrderState.CANCELLED:
      return "Ordine cancellato";
    case OrderState.MODIFIED:
      return "Modifica in attesa";
    case OrderState.READY:
      return "Pronto";
    case OrderState.ARCHIVED:
      return "Archiviato";
    default:
      return "";
  }
}

enum DriverOrderState { PICKED_UP, ASSIGNED, DELIVERED, HIDDEN }

String translateDriverOrderState(DriverOrderState state) {
  switch (state) {
    case DriverOrderState.ASSIGNED:
      return "Ordini assegnati";
    case DriverOrderState.PICKED_UP:
      return "Ordine in consegna";
    case DriverOrderState.DELIVERED:
      return "Ordini consegnati";
    default:
      return "";
  }
}

DriverOrderState orderStateToDriverOrderState(OrderState state) {
  if (state == OrderState.ACCEPTED || state == OrderState.READY) return DriverOrderState.ASSIGNED;
  if (state == OrderState.PICKED_UP) return DriverOrderState.PICKED_UP;
  if (state == OrderState.DELIVERED) return DriverOrderState.DELIVERED;
  return DriverOrderState.HIDDEN;
}

@JsonSerializable(anyMap: true, explicitToJson: true, nullable: true, includeIfNull: false)
class OrderModel extends FirebaseModel {
  final List<OrderProductModel> products;
  final List<OrderProductModel> newProducts;
  final int productCount;
  final double totalPrice;
  final int newProductCount;
  final double newTotalPrice;
  final String notes;

  final OrderState state;
  @JsonKey(defaultValue: false)
  final bool hasSupplierReview;
  @JsonKey(defaultValue: false)
  final bool hasDriverReview;

  // Timestamps
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime creationTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime acceptanceTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime preferredDeliveryTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime modificationTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime cancellationTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime readyTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime pickupTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime deliveryTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime refusalTimestamp;
  @JsonKey(toJson: datetimeToJson, fromJson: datetimeFromJson)
  final DateTime archiviationTimestamp;

  // Customer info
  final String customerId;
  final String customerName;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final String customerPhoneNumber;
  final String customerImageUrl;
  final String cardId;

  // Supplier info
  final String supplierId;
  final String supplierName;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint supplierCoordinates;
  final String supplierAddress;
  final String supplierPhoneNumber;
  final String supplierImageUrl;

  // Driver info
  final String driverId;
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;

  OrderModel({
    String path,
    this.productCount,
    this.notes,
    this.totalPrice,
    this.newProductCount,
    this.newTotalPrice,
    this.preferredDeliveryTimestamp,
    this.modificationTimestamp,
    this.cancellationTimestamp,
    this.readyTimestamp,
    this.pickupTimestamp,
    this.deliveryTimestamp,
    this.customerName,
    this.customerCoordinates,
    this.customerAddress,
    this.customerPhoneNumber,
    this.customerImageUrl,
    this.supplierName,
    this.supplierCoordinates,
    this.supplierAddress,
    this.supplierPhoneNumber,
    this.supplierImageUrl,
    this.driverName,
    this.driverPhoneNumber,
    this.driverImageUrl,
    this.supplierId,
    this.driverId,
    this.hasSupplierReview,
    this.hasDriverReview,
    this.customerId,
    this.products,
    this.newProducts,
    this.creationTimestamp,
    this.acceptanceTimestamp,
    this.refusalTimestamp,
    this.archiviationTimestamp,
    this.state,
    this.cardId,
  }) : super(path);

  List<LatLng> get positions => [LatLng(customerCoordinates.latitude, customerCoordinates.longitude)];

  static OrderModel fromJson(Map json) => _$OrderModelFromJson(json);

  static OrderModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @required
  String toString() => toJson().toString();
}
