import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductModel.g.dart';

/// Represents a product that the supplier sells

@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductModel extends FirebaseModel {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final int maxQuantity;
  final String type;
  final ProductCategory category;
  final String supplierId;

  ProductModel({
    String path,
    @required this.name,
    @required this.description,
    @required this.price,
    @required this.maxQuantity,
    @required this.type,
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

enum ProductCategory { APPETIZER, FIRST_COURSES, MAIN_COURSES, SEAFOOD_MENU, MEAT_MENU, SIDE_DISH, DESERT, DRINK, WINE, ALCOHOLIC, COFFEE }

String translateProductCategory(ProductCategory category) {
  switch (category) {
    case ProductCategory.APPETIZER:
      return "Antipasti";
    case ProductCategory.FIRST_COURSES:
      return "Primi Piatti";
    case ProductCategory.MAIN_COURSES:
      return "Secondi Piatti";
    case ProductCategory.SEAFOOD_MENU:
      return "Menu di Mare";
    case ProductCategory.MEAT_MENU:
      return "Menu di Terra";
    case ProductCategory.SIDE_DISH:
      return "Contorni";
    case ProductCategory.DESERT:
      return "Desert";
    case ProductCategory.DRINK:
      return "Bevande";
    case ProductCategory.WINE:
      return "Vini";
    case ProductCategory.ALCOHOLIC:
      return "Alcolici";
    case ProductCategory.COFFEE:
      return "Caffetteria";
    default:
      return "";
  }
}

enum ProductStates { PENDING, ACCEPTED, REFUSED }
