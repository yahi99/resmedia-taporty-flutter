import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_core/src/models/CartProductModel.dart';

part 'CartModel.g.dart';

// TODO: Rimuovi l'utilizzo dei metodi getTotalItems e getTotalPrice in quanto non è detto che i prodotti salvati nello storage siano ancora presenti nel database
@JsonSerializable(anyMap: true, explicitToJson: true)
class CartModel {
  final List<CartProductModel> products;

  const CartModel({this.products: const []}) : assert(products != null);

  CartProductModel getProduct(String id, String supplierId, String userId) {
    return products.firstWhere((item) => item.id == id && item.supplierId == supplierId && item.userId == userId, orElse: () => null);
  }

  int getTotalItems(List<CartProductModel> products) {
    return products.fold(0, (price, product) => price + product.quantity);
  }

  double getPrice(String id, double price, String supplierId, String userId) => (price * getProduct(id, supplierId, userId).quantity.toDouble());

  double getTotalPrice(List<CartProductModel> products, String uid, String supplierId) {
    return products.fold(0, (price, product) => price + ((getProduct(product.id, supplierId, uid) == product) ? getPrice(product.id, product.price, product.supplierId, product.userId) : 0));
  }

  bool increment(String id, String supplierId, String userId, double price, String type) {
    final product = getProduct(id, supplierId, userId);
    return product == null ? onInsert(CartProductModel(id: id, quantity: 1, supplierId: supplierId, userId: userId, price: price, type: type)) : onIncrement(product.increment());
  }

  bool delete(String id, String restId, String uid) {
    final product = getProduct(id, restId, uid);
    return product == null ? false : onDelete(product.deleteItem(true));
  }

  @protected
  bool onInsert(CartProductModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onIncrement(CartProductModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onDelete(CartProductModel product) {
    _update(product);
    return true;
  }

  bool decrease(String id, String supplierId, String userId) {
    var product = getProduct(id, supplierId, userId);
    if (product == null) return false;
    product = product.decrease();
    return product.quantity <= 0 ? onRemove(product) : onDecrease(product);
  }

  bool remove(String id, String supplierId, String userId) {
    var product = getProduct(id, supplierId, userId);
    if (product == null) return false;
    return onRemove(product);
  }

  @protected
  bool onDecrease(CartProductModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onRemove(CartProductModel product) {
    products.remove(product);
    return true;
  }

  _update(CartProductModel product) {
    assert(product != null);
    products.remove(product);
    products.add(product);
  }

  Iterable<String> get idProducts => products.map((prod) => prod.id);
  static CartModel fromJson(Map json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
