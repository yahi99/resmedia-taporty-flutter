import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/SupplierModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:rxdart/rxdart.dart';

class SupplierBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _supplierController?.close();
    _productsController?.close();
    _foodsController?.close();
    _drinksController?.close();
    _supplierReviewController.close();
  }

  BehaviorSubject<SupplierModel> _supplierController;

  Stream<SupplierModel> get outSupplier => _supplierController.stream;

  BehaviorSubject<List<ReviewModel>> _supplierReviewController;

  Stream<List<ReviewModel>> get outSupplierReview => _supplierReviewController.stream;

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

  SupplierBloc.instance();

  factory SupplierBloc.of() => $Provider.of<SupplierBloc>();

  factory SupplierBloc.init({@required String supplierId}) {
    final bc = SupplierBloc.of();
    bc._supplierController = BehaviorController.catchStream(source: bc._db.getSupplierStream(supplierId));
    bc._productsController = BehaviorController.catchStream(source: bc._db.getProductListStream(supplierId));
    bc._foodsController = BehaviorController.catchStream(source: bc._db.getFoodListStream(supplierId));
    bc._drinksController = BehaviorController.catchStream(source: bc._db.getDrinkListStream(supplierId));
    bc._supplierReviewController = BehaviorController.catchStream(source: bc._db.getReviewListStream(supplierId));
    return bc;
  }

  static void close() => $Provider.dispose<SupplierBloc>();
}
