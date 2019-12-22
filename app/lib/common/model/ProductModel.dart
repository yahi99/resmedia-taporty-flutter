import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductModel.g.dart';

abstract class ProductModel extends FirebaseModel {
  final String title;
  String img;
  final String price;
  final String restaurantId;
  final String number;
  final bool isDisabled;

  ProductModel({
    String path,
    this.number,
    this.isDisabled,
    this.title,
    this.img,
    @required this.price,
    @required this.restaurantId,
  }) : super(path);
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class FoodModel extends ProductModel {
  final String img;
  final FoodCategory category;
  final String restaurantId;
  final String number;
  final bool isDisabled;

  FoodModel({
    String path,
    this.img,
    this.isDisabled,
    String price,
    this.category,
    this.restaurantId,
    this.number,
  }) : super(
          path: path,
          price: price,
          restaurantId: restaurantId,
          number: number,
          isDisabled: isDisabled,
        );

  static FoodModel fromJson(Map json) => _$FoodModelFromJson(json);

  static FoodModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$FoodModelToJson(this);

  @required
  String toString() => toJson().toString();
}

enum FoodCategory {
  APPETIZER,
  FIRST_COURSES,
  MAIN_COURSES,
  SEAFOOD_MENU,
  MEAT_MENU,
  SIDE_DISH,
  DESERT,
  DRINK,
  WINE,
  ALCOHOLIC,
  COFFEE
}

String translateFoodCategory(FoodCategory category) {
  switch (category) {
    case FoodCategory.APPETIZER:
      return "Antipasti";
    case FoodCategory.FIRST_COURSES:
      return "Primi Piatti";
    case FoodCategory.MAIN_COURSES:
      return "Secondi Piatti";
    case FoodCategory.SEAFOOD_MENU:
      return "Menu di Mare";
    case FoodCategory.MEAT_MENU:
      return "Menu di Terra";
    case FoodCategory.SIDE_DISH:
      return "Contorni";
    case FoodCategory.DESERT:
      return "Desert";
    case FoodCategory.DRINK:
      return "Bevande";
    case FoodCategory.WINE:
      return "Vini";
    case FoodCategory.ALCOHOLIC:
      return "Alcolici";
    case FoodCategory.COFFEE:
      return "Caffetteria";
    default:
      return "";
  }
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DrinkModel extends ProductModel {
  final DrinkCategory category;
  final String img;
  final String restaurantId;
  final String number;
  final bool isDisabled;

  DrinkModel(
      {String path,
      this.category,
      this.isDisabled,
      this.img,
      String price,
      this.restaurantId,
      this.number})
      : super(
          path: path,
          price: price,
          restaurantId: restaurantId,
          number: number,
          isDisabled: isDisabled,
        );

  static DrinkModel fromJson(Map json) => _$DrinkModelFromJson(json);

  static DrinkModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);

  @required
  String toString() => toJson().toString();
}

enum DrinkCategory { DRINK, WINE, ALCOHOLIC, COFFEE }

String translateDrinkCategory(DrinkCategory category) {
  switch (category) {
    case DrinkCategory.DRINK:
      return "Bevande";
    case DrinkCategory.WINE:
      return "Vini";
    case DrinkCategory.ALCOHOLIC:
      return "Alcolici";
    case DrinkCategory.COFFEE:
      return "Caffetteria";
    default:
      return "";
  }
}
