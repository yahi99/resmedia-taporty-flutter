import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_flutter/common/helper/GeopointSerialization.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderProductModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';

part 'OrderModel.g.dart';

enum OrderState { NEW, ACCEPTED, MODIFIED, CANCELLED, READY, PICKED_UP, DELIVERED, ARCHIVED, REFUSED }

String translateOrderState(OrderState state) {
  switch (state) {
    case OrderState.PICKED_UP:
      return "Ritirato dal fattorino";
    case OrderState.REFUSED:
      return "Ordine rifiutato";
    case OrderState.NEW:
      return "In Accettazione";
    case OrderState.ACCEPTED:
      return "In Consegna";
    case OrderState.DELIVERED:
      return "Consegnato";
    case OrderState.CANCELLED:
      return "Ordine Cancellato";
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

@JsonSerializable(anyMap: true, explicitToJson: true, nullable: true, includeIfNull: false)
class OrderModel extends FirebaseModel {
  final List<OrderProductModel> products;
  final int productCount;
  final double totalPrice;
  final int newProductCount;
  final double newTotalPrice;

  final OrderState state;
  final bool isReviewed;

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

  // Customer info
  final String customerId;
  final String customerName;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint customerCoordinates;
  final String customerAddress;
  final String customerPhoneNumber;
  final String customerImageUrl;
  final String cardId;

  // Restaurant info
  final String restaurantId;
  final String restaurantName;
  @JsonKey(toJson: geopointToJson, fromJson: geopointFromJson)
  final GeoPoint restaurantCoordinates;
  final String restaurantAddress;
  final String restaurantPhoneNumber;
  final String restaurantImageUrl;

  // Driver info
  final String driverId;
  final String driverName;
  final String driverPhoneNumber;
  final String driverImageUrl;

  OrderModel({
    String path,
    this.productCount,
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
    this.restaurantName,
    this.restaurantCoordinates,
    this.restaurantAddress,
    this.restaurantPhoneNumber,
    this.restaurantImageUrl,
    this.driverName,
    this.driverPhoneNumber,
    this.driverImageUrl,
    this.restaurantId,
    this.driverId,
    this.isReviewed,
    this.customerId,
    this.products,
    this.creationTimestamp,
    this.acceptanceTimestamp,
    this.state,
    this.cardId,
  }) : super(path);

  List<LatLng> get positions => [LatLng(customerCoordinates.latitude, customerCoordinates.longitude)];

  List<SubjectModel> get subjects => [
        SubjectModel(
          day: "day",
          name: restaurantName,
          address: restaurantAddress,
          displayName: restaurantName,
          time: (acceptanceTimestamp != null) ? acceptanceTimestamp : 'Ordine non accettato',
        ),
        SubjectModel(
            day: "day",
            name: customerName,
            address: customerAddress,
            time: "time/creationTimestamp",
            displayName: customerName,
            position: LatLng(customerCoordinates.latitude, customerCoordinates.longitude))
      ];

  static OrderModel fromJson(Map json) => _$OrderModelFromJson(json);

  static OrderModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  @required
  String toString() => toJson().toString();
}
