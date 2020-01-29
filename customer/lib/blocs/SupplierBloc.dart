import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class SupplierBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _supplierIdController.close();
    _supplierController?.close();
    _productsController?.close();
    _foodsController?.close();
    _drinksController?.close();
    _supplierReviewController.close();
  }

  BehaviorSubject<String> _supplierIdController;

  Stream<String> get outSupplierId => _supplierIdController.stream;
  String get supplierId => _supplierIdController.value;

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

  SupplierBloc.instance() {
    _supplierIdController = BehaviorSubject.seeded(null);
    _supplierController = BehaviorController.catchStream<SupplierModel>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getSupplierStream(supplierId);
    }));
    _productsController = BehaviorController.catchStream<List<ProductModel>>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getProductListStream(supplierId);
    }));
    _foodsController = BehaviorController.catchStream<List<ProductModel>>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getFoodListStream(supplierId);
    }));
    _drinksController = BehaviorController.catchStream<List<ProductModel>>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getDrinkListStream(supplierId);
    }));
    _supplierReviewController = BehaviorController.catchStream<List<ReviewModel>>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getReviewListStream(supplierId);
    }));
  }

  void setSupplier(String supplierId) {
    _supplierIdController.add(supplierId);
  }

  void clear() {
    _supplierIdController.value = null;
  }
}
