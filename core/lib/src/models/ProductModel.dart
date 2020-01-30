import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductModel.g.dart';

/// Rappresenta un prodotto venduta dal fornitore

@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductModel extends FirebaseModel {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int maxQuantity;
  final String category;
  final String supplierId;

  ProductModel({
    String path,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.maxQuantity,
    @required this.category,
    @required this.supplierId,
    this.imageUrl,
  }) : super(path);

  static ProductModel fromJson(Map json) => _$ProductModelFromJson(json);

  static ProductModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @required
  String toString() => toJson().toString();
}

enum ProductStates { PENDING, ACCEPTED, REFUSED }
