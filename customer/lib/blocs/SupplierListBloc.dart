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

  // Controller per l'id della categoria selezionata
  BehaviorSubject<String> _categoryIdController;

  // Controller per la categoria selezionata
  BehaviorSubject<SupplierCategoryModel> _categoryController;

  // Controller per i fornitori ottenuti dal database
  BehaviorSubject<List<SupplierModel>> _supplierListController;

  // Controller per i tag selezionati dall'utente
  BehaviorSubject<List<String>> _tagListController;

  SupplierCategoryModel get category => _categoryController.value;

  Stream<List<String>> get outSelectedTags => _tagListController.stream;

  Stream<SupplierCategoryModel> get outCategory => _categoryController.stream;

  Stream<List<SupplierModel>> get outSuppliers => CombineLatestStream.combine4(
        searchBarController,
        _categoryIdController,
        _tagListController,
        _supplierListController,
        filteredSuppliers,
      );

  Stream<List<SupplierCategoryModel>> get outCategories => CombineLatestStream.combine3(
        searchBarController,
        _categoryListController,
        _supplierListController,
        filteredCategories,
      );

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
  }

  List<SupplierCategoryModel> filteredCategories(String searchBarValue, List<SupplierCategoryModel> categories, List<SupplierModel> suppliers) {
    return categories?.where((category) {
      if (!category.name.toLowerCase().contains(searchBarValue.toLowerCase())) return false;
      if (!suppliers.any((s) => s.category == category.id)) return false;
      return true;
    })?.toList();
  }

  List<SupplierModel> filteredSuppliers(String searchBarValue, String categoryId, List<String> tags, List<SupplierModel> suppliers) {
    return suppliers?.where((supplier) {
      if (supplier.category != categoryId) return false;
      if (!supplier.name.toLowerCase().contains(searchBarValue.toLowerCase())) return false;
      if (tags == null || tags.length == 0) return true;
      for (var tag in tags) {
        if (supplier.tags.contains(tag)) {
          return true;
        }
      }
      return false;
    })?.toList();
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

  List<String> get _tags => _tagListController.value;
  void toggleTag(String tag) {
    if (_tags.contains(tag))
      _tags.remove(tag);
    else
      _tags.add(tag);
    _tagListController.add(_tags);
  }
}
