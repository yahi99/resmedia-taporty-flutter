import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantController?.close();
    _productsController?.close();
    _foodsController?.close();
    _drinksController?.close();
    _restaurantReviewController.close();
  }

  BehaviorSubject<RestaurantModel> _restaurantController;

  Stream<RestaurantModel> get outRestaurant => _restaurantController.stream;

  BehaviorSubject<List<ReviewModel>> _restaurantReviewController;

  Stream<List<ReviewModel>> get outRestaurantReview => _restaurantReviewController.stream;

  BehaviorSubject<List<ProductModel>> _productsController;

  Stream<List<ProductModel>> get outProducts => _productsController;

  Stream<Map<ProductCategory, List<ProductModel>>> get outProductsByCategory => outProducts.map((models) {
        return categorized(ProductCategory.values, models, (model) => model.category);
      });

  BehaviorSubject<List<ProductModel>> _foodsController;

  Stream<List<ProductModel>> get outFoods => _foodsController;

  Stream<Map<ProductCategory, List<ProductModel>>> get outFoodsByCategory => outFoods.map((models) {
        return categorized(ProductCategory.values, models, (model) => model.category);
      });

  BehaviorSubject<List<ProductModel>> _drinksController;

  Stream<List<ProductModel>> get outDrinks => _drinksController;

  Stream<Map<ProductCategory, List<ProductModel>>> get outDrinksByCategory => outDrinks.map((models) {
        return categorized(ProductCategory.values, models, (model) => model.category);
      });

  bool isInit = false;

  RestaurantBloc.instance();

  factory RestaurantBloc.of() => $Provider.of<RestaurantBloc>();

  factory RestaurantBloc.init({@required String restaurantId}) {
    final bc = RestaurantBloc.of();
    bc._restaurantController = BehaviorController.catchStream(source: bc._db.getRestaurant(restaurantId));
    bc._productsController = BehaviorController.catchStream(source: bc._db.getProducts(restaurantId));
    bc._foodsController = BehaviorController.catchStream(source: bc._db.getFoods(restaurantId));
    bc._drinksController = BehaviorController.catchStream(source: bc._db.getDrinks(restaurantId));
    bc._restaurantReviewController = BehaviorController.catchStream(source: bc._db.getReviews(restaurantId));
    return bc;
  }

  static void close() => $Provider.dispose<RestaurantBloc>();
}
