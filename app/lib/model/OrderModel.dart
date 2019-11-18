import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'OrderModel.g.dart';

abstract class OrderModel extends FirebaseModel {
  final List<ProductCart> products;

  OrderModel({
    String path,
    @required this.products,
  }) : super(path);
}

enum StateCategory { PENDING, ACCEPTED, DONE, DENIED, PICKED_UP }

String translateOrderCategory(StateCategory category) {
  switch (category) {
    case StateCategory.PICKED_UP:
      return "Ritirato dal fattorino";
    case StateCategory.DENIED:
      return "Ordine rifiutato";
    case StateCategory.PENDING:
      return "In Accettazione";
    case StateCategory.ACCEPTED:
      return "In Consegna";
    case StateCategory.DONE:
      return "Consegnato";
    default:
      return "";
  }
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class RestaurantOrderModel extends OrderModel {
  final List<ProductCart> products;
  final String timeR, timeS;
  final StateCategory state;
  final String startTime, endTime;
  final String driver;
  final String uid;
  final String nominative;
  final String addressR;
  final String stripe_customer;
  final String day;
  final String phone;

  RestaurantOrderModel({
    String path,
    @required this.phone,
    @required this.day,
    @required this.stripe_customer,
    @required this.addressR,
    @required this.endTime,
    @required this.products,
    @required this.driver,
    @required this.uid,
    @required this.timeR,
    @required this.timeS,
    @required this.state,
    @required this.startTime,
    @required this.nominative,
  }) : super(path: path, products: products);

  static RestaurantOrderModel fromJson(Map json) =>
      _$RestaurantOrderModelFromJson(json);

  static RestaurantOrderModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$RestaurantOrderModelToJson(this);

  @required
  String toString() => toJson().toString();
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class UserOrderModel extends OrderModel {
  final List<ProductCart> products;
  final String timeR, timeS;
  final StateCategory state;
  final String endTime,day,phone;

  UserOrderModel({
    String path,
    @required this.phone,
    @required this.day,
    @required this.endTime,
    @required this.products,
    @required this.timeR,
    @required this.timeS,
    @required this.state,
  }) : super(path: path, products: products);

  static UserOrderModel fromJson(Map json) => _$UserOrderModelFromJson(json);

  static UserOrderModel fromFirebase(DocumentSnapshot snap) =>
      FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$UserOrderModelToJson(this);

  @required
  String toString() => toJson().toString();
}

/*enum FoodCategory {
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
}*/
