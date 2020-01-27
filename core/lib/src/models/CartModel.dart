import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/CartProductModel.dart';

part 'CartModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class CartModel {
  final List<CartProductModel> products;

  @JsonKey(ignore: true)
  List<ProductModel> supplierProducts;

  CartModel.defaultValue() : this(products: List<CartProductModel>());

  CartModel({this.products: const []}) : assert(products != null);

  void updateWithNewProductList(List<ProductModel> newSupplierProducts) {
    supplierProducts.clear();
    for (int i = 0; i < newSupplierProducts.length; i++) {
      var product = newSupplierProducts.elementAt(i);
      var cartProductFound = getProduct(product.id);
      if (cartProductFound == null || cartProductFound.quantity <= 0) {
        onRemove(cartProductFound);
      } else {
        supplierProducts.add(product);
      }
    }
  }

  int get totalItems => products.fold(0, (_prev, p) => _prev + p.quantity);

  double get totalPrice => products.fold(0, (_prev, p) => _prev + p.totalPrice);

  CartProductModel getProduct(String id) {
    return products.firstWhere((item) => item.id == id, orElse: () => null);
  }

  void decrease(String id) {
    var product = getProduct(id);
    if (product == null) return;
    product = product.decrease();
    if (product.quantity <= 0)
      onRemove(product);
    else
      _update(product);
  }

  void remove(String id) {
    var product = getProduct(id);
    if (product != null) onRemove(product);
  }

  void increment(String id, double price, String type) {
    final product = getProduct(id);
    if (product == null)
      _update(CartProductModel(id: id, quantity: 1, price: price, type: type));
    else
      _update(product.increment());
  }

  void delete(String id) {
    final product = getProduct(id);
    if (product != null) onRemove(product);
  }

  @protected
  void onRemove(CartProductModel product) {
    products.remove(product);
  }

  _update(CartProductModel product) {
    assert(product != null);
    products.remove(product);
    products.add(product);
  }

  static CartModel fromJson(Map json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
