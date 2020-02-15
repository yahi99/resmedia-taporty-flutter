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
    _deselectedCategoryIdListController?.close();
    _isSelectingCategoryController?.close();
  }

  BehaviorSubject<String> _supplierIdController;

  BehaviorSubject<SupplierModel> _supplierController;

  BehaviorSubject<List<String>> _deselectedCategoryIdListController;

  BehaviorSubject<List<ProductModel>> _productsController;

  BehaviorSubject<bool> _isSelectingCategoryController;

  BehaviorSubject<List<ReviewModel>> _supplierReviewController;

  Stream<String> get outSupplierId => _supplierIdController.stream;
  String get supplierId => _supplierIdController.value;

  Stream<SupplierModel> get outSupplier => _supplierController.stream;
  SupplierModel get supplier => _supplierController.value;

  Stream<List<ProductModel>> get outProducts => _productsController;

  Stream<bool> get outIsSelectingCategories => _isSelectingCategoryController.stream;

  Stream<Map<String, List<ProductModel>>> get outProductsByCategory => CombineLatestStream.combine2(
        _supplierController,
        _productsController,
        productsByCategory,
      );

  Stream<List<Tuple2<ProductCategoryModel, bool>>> get outProductCategories => CombineLatestStream.combine3(
        _supplierController,
        _deselectedCategoryIdListController,
        _productsController,
        productCategories,
      );

  Stream<List<ReviewModel>> get outSupplierReviews => _supplierReviewController.stream;

  SupplierBloc.instance() {
    _supplierIdController = BehaviorSubject.seeded(null);
    _deselectedCategoryIdListController = BehaviorSubject.seeded(List());
    _isSelectingCategoryController = BehaviorSubject.seeded(false);
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
    _deselectedCategoryIdListController.value = List();
    _isSelectingCategoryController.value = false;
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

  List<Tuple2<ProductCategoryModel, bool>> productCategories(SupplierModel supplier, List<String> deselectedCategoryIds, List<ProductModel> products) {
    if (products == null) return null;
    if (supplier.categories == null || supplier.categories.isEmpty) return null;

    var categories = supplier.categories.where((category) => products.any((p) => p.category == category.id)).toList();

    List list = List<Tuple2<ProductCategoryModel, bool>>();
    for (var category in categories) {
      var selected = false;
      if (deselectedCategoryIds != null && !deselectedCategoryIds.any((c) => c == category.id)) selected = true;
      list.add(Tuple2<ProductCategoryModel, bool>(category, selected));
    }

    if (supplier.categories == null || supplier.categories.isEmpty) {
      list.add(Tuple2<ProductCategoryModel, bool>(ProductCategoryModel.defaultValue(), true));
    }

    return list;
  }

  bool get _isSelectingCategory => _isSelectingCategoryController.value;
  void toggleCategorySelection() {
    _isSelectingCategoryController.add(!_isSelectingCategory);
  }

  List<String> get _selectedCategories => _deselectedCategoryIdListController.value;
  void toggleCategory(String categoryId) {
    if (_selectedCategories.contains(categoryId))
      _selectedCategories.remove(categoryId);
    else
      _selectedCategories.add(categoryId);
    _deselectedCategoryIdListController.add(_selectedCategories);
  }
}
