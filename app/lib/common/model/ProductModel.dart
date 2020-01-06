import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ProductModel extends FirebaseModel {
  final String name;
  final double price;
  final String imageUrl;
  final int maxQuantity;
  final String type;
  @JsonKey(fromJson: categoryFromJson, toJson: categoryToJson)
  final ProductCategory category;
  final String restaurantId;

  ProductModel({
    String path,
    @required this.name,
    @required this.price,
    @required this.maxQuantity,
    @required this.type,
    @required this.category,
    @required this.restaurantId,
    @required this.imageUrl,
  }) : super(path);

  static ProductModel fromJson(Map json) => _$ProductModelFromJson(json);

  static ProductModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);

  @required
  String toString() => toJson().toString();
}

enum ProductCategory { APPETIZER, FIRST_COURSES, MAIN_COURSES, SEAFOOD_MENU, MEAT_MENU, SIDE_DISH, DESERT, DRINK, WINE, ALCOHOLIC, COFFEE }

ProductCategory categoryFromJson(String input) {
  switch (input) {
    case 'appetizer':
      return ProductCategory.APPETIZER;
    case 'first_courses':
      return ProductCategory.FIRST_COURSES;
    case 'main_courses':
      return ProductCategory.MAIN_COURSES;
    case 'seafood_menu':
      return ProductCategory.SEAFOOD_MENU;
    case 'meat_menu':
      return ProductCategory.MEAT_MENU;
    case 'side_dish':
      return ProductCategory.SIDE_DISH;
    case 'desert':
      return ProductCategory.DESERT;
    case 'drink':
      return ProductCategory.DRINK;
    case 'wine':
      return ProductCategory.WINE;
    case 'alcoholic':
      return ProductCategory.ALCOHOLIC;
    case 'coffee':
      return ProductCategory.COFFEE;
    default:
      return ProductCategory.MAIN_COURSES;
  }
}

String categoryToJson(ProductCategory input) {
  switch (input) {
    case ProductCategory.APPETIZER:
      return 'appetizer';
    case ProductCategory.FIRST_COURSES:
      return 'first_courses';
    case ProductCategory.MAIN_COURSES:
      return 'main_courses';
    case ProductCategory.SEAFOOD_MENU:
      return 'seafood_menu';
    case ProductCategory.MEAT_MENU:
      return 'meat_menu';
    case ProductCategory.SIDE_DISH:
      return 'side_dish';
    case ProductCategory.DESERT:
      return 'desert';
    case ProductCategory.DRINK:
      return 'drink';
    case ProductCategory.WINE:
      return 'wine';
    case ProductCategory.ALCOHOLIC:
      return 'alcoholic';
    case ProductCategory.COFFEE:
      return 'coffee';
    default:
      return 'appetizer';
  }
}

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
