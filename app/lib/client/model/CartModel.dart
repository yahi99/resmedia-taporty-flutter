import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';
import 'package:resmedia_taporty_flutter/client/model/ProductCartModel.dart';

part 'CartModel.g.dart';

//TODO i prodotti non sono separati per ristorante quindi se tolgo o metto su uno dopo modifico tutti

@JsonSerializable(anyMap: true, explicitToJson: true)
class CartModel {
  final List<ProductCartModel> products;

  const CartModel({this.products: const []}) : assert(products != null);

  ProductCartModel getProduct(String id, String restaurantId, String userId) {
    return products.firstWhere((item) => item.id == id && item.restaurantId == restaurantId && item.userId == userId, orElse: () => null);
  }

  double multiply(double a, int b) {
    if (b == 1) return a;
    return a + multiply(a, b - 1);
  }

  int getTotalItems(List<ProductCartModel> products) {
    return products.fold(0, (price, product) => price + product.quantity);
  }

  double getPrice(String id, double price, String restaurantId, String userId) => (multiply(price, getProduct(id, restaurantId, userId).quantity));

  double getTotalPrice(List<ProductCartModel> products, String uid, String restaurantId) {
    return products.fold(0, (price, product) => price + ((getProduct(product.id, restaurantId, uid) == product) ? getPrice(product.id, product.price, product.restaurantId, product.userId) : 0));
  }

  bool increment(String id, String restaurantId, String userId, double price, String type) {
    final product = getProduct(id, restaurantId, userId);
    return product == null ? onInsert(ProductCartModel(id: id, quantity: 1, restaurantId: restaurantId, userId: userId, price: price, type: type)) : onIncrement(product.increment());
  }

  bool delete(String id, String restId, String uid) {
    final product = getProduct(id, restId, uid);
    return product == null ? false : onDelete(product.deleteItem(true));
  }

  @protected
  bool onInsert(ProductCartModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onIncrement(ProductCartModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onDelete(ProductCartModel product) {
    _update(product);
    return true;
  }

  bool decrease(String id, String restaurantId, String userId) {
    var product = getProduct(id, restaurantId, userId);
    if (product == null) return false;
    product = product.decrease();
    return product.quantity <= 0 ? onRemove(product) : onDecrease(product);
  }

  bool remove(String id, String restaurantId, String userId) {
    var product = getProduct(id, restaurantId, userId);
    if (product == null) return false;
    return onRemove(product);
  }

  @protected
  bool onDecrease(ProductCartModel product) {
    _update(product);
    return true;
  }

  @protected
  bool onRemove(ProductCartModel product) {
    products.remove(product);
    return true;
  }

  _update(ProductCartModel product) {
    assert(product != null);
    products.remove(product);
    products.add(product);
  }

  Iterable<String> get idProducts => products.map((prod) => prod.id);
  static CartModel fromJson(Map json) => _$CartModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartModelToJson(this);
}
