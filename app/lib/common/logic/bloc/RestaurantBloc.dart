import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantController?.close();
    _foodsController?.close();
    _drinksController?.close();
    _foodsControllerCtrl?.close();
    _drinksControllerCtrl?.close();
  }

  BehaviorSubject<RestaurantModel> _restaurantController;

  Stream<RestaurantModel> get outRestaurant => _restaurantController.stream;

  BehaviorSubject<List<ReviewModel>> _restaurantReviewController;

  Stream<List<ReviewModel>> get outRestaurantReview => _restaurantReviewController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController;

  Stream<List<FoodModel>> get outFoods => _foodsController;

  BehaviorSubject<List<FoodModel>> _foodsControllerCtrl;

  Stream<List<FoodModel>> get outFoodsCtrl => _foodsControllerCtrl;

  Stream<Map<FoodCategory, List<FoodModel>>> get outCategorizedFoods =>
      outFoods.map((models) {
        return categorized(
            FoodCategory.values, models, (model) => model.category);
      });

  BehaviorSubject<List<DrinkModel>> _drinksController;

  Stream<List<DrinkModel>> get outDrinks => _drinksController.stream;

  BehaviorSubject<List<DrinkModel>> _drinksControllerCtrl;

  Stream<List<DrinkModel>> get outDrinksCtrl => _drinksControllerCtrl.stream;

  Stream<Map<DrinkCategory, List<DrinkModel>>> get outCategorizedDrinks =>
      outDrinks.map((models) {
        return categorized(
            DrinkCategory.values, models, (model) => model.category);
      });

  bool isInit = false;

  RestaurantBloc.instance();

  factory RestaurantBloc.of() => $Provider.of<RestaurantBloc>();

  factory RestaurantBloc.init({@required String idRestaurant}) {
    final bc = RestaurantBloc.of();
    bc._restaurantController = BehaviorController.catchStream(
        source: bc._db.getRestaurant(idRestaurant));
    bc._foodsController =
        BehaviorController.catchStream(source: bc._db.getFoods(idRestaurant));
    bc._drinksController =
        BehaviorController.catchStream(source: bc._db.getDrinks(idRestaurant));
    bc._foodsControllerCtrl =
        BehaviorController.catchStream(source: bc._db.getFoodsCtrl(idRestaurant));
    bc._drinksControllerCtrl =
        BehaviorController.catchStream(source: bc._db.getDrinksCtrl(idRestaurant));
    bc._restaurantReviewController=
        BehaviorController.catchStream(source: bc._db.getReviews(idRestaurant));
    return bc;
  }

  static void close() => $Provider.dispose<RestaurantBloc>();
}
