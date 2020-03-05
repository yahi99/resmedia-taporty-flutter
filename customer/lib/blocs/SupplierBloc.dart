import 'dart:async';

import 'package:dash/dash.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class SupplierBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _supplierIdController.close();
    _supplierController?.close();
    _productsController?.close();
    _supplierReviewController.close();
    _selectedCategoryIdListController?.close();
  }

  BehaviorSubject<String> _supplierIdController;

  BehaviorSubject<SupplierModel> _supplierController;

  BehaviorSubject<List<String>> _selectedCategoryIdListController;

  BehaviorSubject<List<ProductModel>> _productsController;

  BehaviorSubject<List<ReviewModel>> _supplierReviewController;

  Stream<String> get outSupplierId => _supplierIdController.stream;
  String get supplierId => _supplierIdController.value;

  Stream<SupplierModel> get outSupplier => _supplierController.stream;
  SupplierModel get supplier => _supplierController.value;

  Stream<List<ProductModel>> get outProducts => _productsController;

  Stream<Map<String, List<ProductModel>>> get outProductsByCategory => CombineLatestStream.combine2(
        _supplierController,
        _productsController,
        productsByCategory,
      );

  Stream<List<ProductCategoryModel>> get outProductCategories => CombineLatestStream.combine2(
        _supplierController,
        _productsController,
        productCategories,
      );

  Stream<List<String>> get outSelectedCategories => _selectedCategoryIdListController.stream;

  Stream<List<ReviewModel>> get outSupplierReviews => _supplierReviewController.stream;

  SupplierBloc.instance() {
    _supplierIdController = BehaviorSubject.seeded(null);
    _selectedCategoryIdListController = BehaviorSubject.seeded(List());
    _supplierController = BehaviorController.catchStream<SupplierModel>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getSupplierStream(supplierId);
    }));
    _productsController = BehaviorController.catchStream<List<ProductModel>>(source: _supplierIdController.switchMap((supplierId) {
      if (supplierId == null) return Stream.value(null);
      return _db.getProductListStream(supplierId);
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
    _selectedCategoryIdListController.value = List();
  }

  Map<String, List<ProductModel>> productsByCategory(SupplierModel supplier, List<ProductModel> products) {
    if (products == null) return null;

    Map<String, List<ProductModel>> map = Map();

    if (supplier.categories == null || supplier.categories.isEmpty) {
      map[ProductCategoryModel.defaultValue().id] = products;
      return map;
    }

    for (var category in supplier.categories) {
      var filteredProducts = products.where((p) => p.category == category.id).toList();
      if (filteredProducts.isNotEmpty) map[category.id] = filteredProducts;
    }

    return map;
  }

  List<ProductCategoryModel> productCategories(SupplierModel supplier, List<ProductModel> products) {
    if (products == null) return null;
    if (supplier.categories == null || supplier.categories.isEmpty) return null;

    return supplier.categories.where((category) => products.any((p) => p.category == category.id)).toList();
  }

  List<String> get _selectedCategories => _selectedCategoryIdListController.value;
  void toggleCategory(String categoryId) {
    if (_selectedCategories.contains(categoryId))
      _selectedCategories.remove(categoryId);
    else
      _selectedCategories.add(categoryId);
    _selectedCategoryIdListController.add(_selectedCategories);
  }
}
