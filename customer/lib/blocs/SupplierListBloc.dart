import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/LocationBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class SupplierListBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _filteredCategoryListController.close();
    _filteredSupplierListController.close();
    _supplierListController.close();
    _categoryController.close();
    _categoryIdController.close();
    _tagListController.close();
    searchBarController.close();
    _categoryListController.close();
  }

  // Controller per la SearchBar
  BehaviorSubject<String> searchBarController;

  // Controller per le categorie ottenute dal database
  BehaviorSubject<List<SupplierCategoryModel>> _categoryListController;

  // Controller per le categorie filtrate in base ai fornitori presenti nella zona intorno all'utente e alla SearchBar
  BehaviorSubject<List<SupplierCategoryModel>> _filteredCategoryListController;

  // Controller per l'id della categoria selezionata
  BehaviorSubject<String> _categoryIdController;

  // Controller per la categoria selezionata
  BehaviorSubject<SupplierCategoryModel> _categoryController;

  // Controller per i fornitori ottenuti dal database
  BehaviorSubject<List<SupplierModel>> _supplierListController;

  // Controller per i fornitori filtrati in base a categoria e tag selezionati e alla SearchBar
  BehaviorSubject<List<SupplierModel>> _filteredSupplierListController;

  // Controller per i tag selezionati dall'utente
  BehaviorSubject<List<String>> _tagListController;

  SupplierCategoryModel get category => _categoryController.value;

  Stream<List<String>> get outSelectedTags => _tagListController.stream;

  Stream<SupplierCategoryModel> get outCategory => _categoryController.stream;

  Stream<List<SupplierModel>> get outSuppliers => _filteredSupplierListController.stream;

  Stream<List<SupplierCategoryModel>> get outCategories => _filteredCategoryListController.stream;

  SupplierListBloc.instance() {
    var locationBloc = $Provider.of<LocationBloc>();
    _tagListController = BehaviorSubject.seeded(List<String>());
    _categoryIdController = BehaviorSubject.seeded(null);
    searchBarController = BehaviorSubject.seeded("");
    _categoryListController = BehaviorController.catchStream<List<SupplierCategoryModel>>(source: _db.getSupplierCategoryListStream());

    _categoryController = BehaviorController.catchStream<SupplierCategoryModel>(source: _categoryIdController.switchMap((categoryId) {
      if (categoryId == null) return Stream.value(null);
      return _db.getSupplierCategoryStream(categoryId);
    }));

    _supplierListController = BehaviorController.catchStream<List<SupplierModel>>(source: locationBloc.outCustomerLocation.switchMap((location) {
      if (location?.coordinates == null) return Stream.value(null);
      return _db.getSupplierListByLocationStream(location.coordinates);
    }));

    _filteredCategoryListController = BehaviorSubject();
    _filteredSupplierListController = BehaviorSubject();

    searchBarController.listen((searchBarValue) => updateFilteredStreams(searchBarValue: searchBarValue));
    _categoryListController.listen((categories) => updateFilteredStreams(categories: categories));
    _categoryIdController.listen((categoryId) => updateFilteredStreams(categoryId: categoryId));
    _tagListController.listen((tags) => updateFilteredStreams(tags: tags));
    _supplierListController.listen((suppliers) => updateFilteredStreams(suppliers: suppliers));
  }

  String get _searchBarValue => searchBarController.value;
  List<SupplierCategoryModel> get _categories => _categoryListController.value;
  String get _categoryId => _categoryIdController.value;
  List<String> get _tags => _tagListController.value;
  List<SupplierModel> get _suppliers => _supplierListController.value;

  void updateFilteredStreams({String searchBarValue, List<SupplierCategoryModel> categories, String categoryId, List<String> tags, List<SupplierModel> suppliers}) {
    searchBarValue = searchBarValue ?? _searchBarValue;
    categories = categories ?? _categories;
    categoryId = categoryId ?? _categoryId;
    tags = tags ?? _tags;
    suppliers = suppliers ?? _suppliers;

    if (categoryId == null && suppliers != null && categories != null)
      updateFilteredCategories(searchBarValue, categories, suppliers);
    else if (categoryId != null && suppliers != null) updateFilteredSuppliers(searchBarValue, categoryId, tags, suppliers);
  }

  void updateFilteredCategories(String searchBarValue, List<SupplierCategoryModel> categories, List<SupplierModel> suppliers) {
    _filteredCategoryListController.add(categories?.where((category) {
      if (!category.name.toLowerCase().contains(searchBarValue.toLowerCase())) return false;
      if (!suppliers.any((s) => s.category == category.id)) return false;
      return true;
    })?.toList());
  }

  void updateFilteredSuppliers(String searchBarValue, String categoryId, List<String> tags, List<SupplierModel> suppliers) {
    _filteredSupplierListController.add(suppliers?.where((supplier) {
      if (supplier.category != categoryId) return false;
      if (!supplier.name.toLowerCase().contains(searchBarValue.toLowerCase())) return false;
      if (tags == null || tags.length == 0) return true;
      for (var tag in tags) {
        if (supplier.tags.contains(tag)) {
          return true;
        }
      }
      return false;
    })?.toList());
  }

  void clear() {
    _categoryIdController.value = null;
    _tagListController.value = List<String>();
    searchBarController.value = "";
  }

  void setCategory(String categoryId) {
    searchBarController.value = "";
    _categoryIdController.value = categoryId;
  }

  void toggleTag(String tag) {
    if (_tags.contains(tag))
      _tags.remove(tag);
    else
      _tags.add(tag);
    _tagListController.add(_tags);
  }
}
