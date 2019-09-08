import 'dart:async';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:mobile_app/model/RestaurantModel.dart';
import 'package:rxdart/rxdart.dart';


class RestaurantBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantController?.close();
    _foodsController?.close();
    _drinksController?.close();
  }

  BehaviorSubject<RestaurantModel> _restaurantController;
  Stream<RestaurantModel> get outRestaurant => _restaurantController.stream;

  BehaviorSubject<List<FoodModel>> _foodsController;
  Stream<List<FoodModel>> get outFoods => _foodsController;
  Stream<Map<FoodCategory, List<FoodModel>>> get outCategorizedFoods => outFoods.map((models) {
    return categorized(FoodCategory.values, models, (model) => model.category);
  });

  BehaviorSubject<List<DrinkModel>> _drinksController;
  Stream<List<DrinkModel>> get outDrinks => _drinksController.stream;
  Stream<Map<DrinkCategory, List<DrinkModel>>> get outCategorizedDrinks => outDrinks.map((models) {
    return categorized(DrinkCategory.values, models, (model) => model.category);
  });

  bool isInit = false;
  RestaurantBloc.instance();
  factory RestaurantBloc.of() => $Provider.of<RestaurantBloc>();
  factory RestaurantBloc.init({@required String idRestaurant}) {
    final bc = RestaurantBloc.of();
    bc._restaurantController = BehaviorController.catchStream(source: bc._db.getRestaurant(idRestaurant));
    bc._foodsController = BehaviorController.catchStream(source: bc._db.getFoods(idRestaurant));
    bc._drinksController = BehaviorController.catchStream(source: bc._db.getDrinks(idRestaurant));
    return bc;
  }
  static void close() => $Provider.dispose<RestaurantBloc>();
}