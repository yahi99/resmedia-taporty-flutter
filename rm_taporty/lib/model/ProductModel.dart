import 'package:meta/meta.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProductModel.g.dart';

abstract class ProductModel extends FirebaseModel {
  final String title;
  String img;
  final String price;
  final String restaurantId;

  ProductModel({String path,
    @required this.title,
    @required this.img,
    @required this.price,
    @required this.restaurantId,
  }) : super(path);
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class FoodModel extends ProductModel {
  final String img;
  final FoodCategory category;
  final String restaurantId;

  FoodModel({String path,
    this.img,String price,
    this.category,
    this.restaurantId
  }) :
        super(
        path: path,
        price: price,
        restaurantId : restaurantId,
      );

  static FoodModel fromJson(Map json) => _$FoodModelFromJson(json);
  static FoodModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$FoodModelToJson(this);
  @required
  String toString() => toJson().toString();
}


enum FoodCategory {
  APPETIZER, FIRST_COURSES, MAIN_COURSES, SEAFOOD_MENU, MEAT_MENU, SIDE_DISH, DESERT,
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
    default: return "";
  }
}


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class DrinkModel extends ProductModel {
  final DrinkCategory category;
  final String img;
  final String restaurantId;

  DrinkModel({String path, this.category, this.img,
    String price, this.restaurantId
  }) : super(
    path: path,
    price: price,
    restaurantId:restaurantId,
  );

  static DrinkModel fromJson(Map json) => _$DrinkModelFromJson(json);
  static DrinkModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);
  Map<String, dynamic> toJson() => _$DrinkModelToJson(this);

  @required
  String toString() => toJson().toString();
}


enum DrinkCategory {
  DRINK, WINE, ALCOHOLIC, COFFEE
}

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
    default: return "";
  }
}
