import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'OrderProductModel.g.dart';

/// Represents a product in an order already done

@JsonSerializable(anyMap: true, explicitToJson: true)
class OrderProductModel {
  final String name;
  final double price;
  final String imageUrl;
  final int quantity;

  OrderProductModel({
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
  });

  static OrderProductModel fromJson(Map json) => _$OrderProductModelFromJson(json);

  static OrderProductModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);

  @required
  String toString() => toJson().toString();
}
