import 'package:flutter/cupertino.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';


part 'Cart.g.dart';

//TODO i prodotti non sono separati per ristorante quindi se tolgo o metto su uno dopo modifico tutti

@JsonSerializable(anyMap: true, explicitToJson: true)
class Cart {
  final List<ProductCart> products;

  const Cart({this.products: const []}) : assert(products != null);

  ProductCart getProduct(String id ,String restaurantId,String userId) {
    return products.firstWhere((item) => item.id == id && item.restaurantId==restaurantId && item.userId==userId, orElse: () => null);
  }

  double multiply(double a, int b){
    if(b==1) return a;
    return a+multiply(a,b-1);
  }

  int getTotalItems(List<ProductCart> products, String uid,String restaurantId){
    return products.fold(0, (price, product) =>
    price + ((getProduct(product.id, restaurantId, uid)==product)?product.countProducts:0));
  }

  double getPrice(String id, double price,String restaurantId,String userId) => (multiply(price,getProduct(id,restaurantId,userId).countProducts));

  double getTotalPrice(List<ProductCart> products, String uid,String restaurantId) {
    return products.fold(0, (price, product) =>
      price + ((getProduct(product.id, restaurantId, uid)==product)?getPrice(product.id, product.price,product.restaurantId,product.userId):0));
  }

  bool increment(String id,String restaurantId,String userId,double price,String category) {
    final product = getProduct(id,restaurantId,userId);
    return product == null
        ? onInsert(ProductCart(id: id, countProducts: 1,restaurantId: restaurantId,userId:userId,price: price,category: category))
        : onIncrement(product.increment());
  }

  bool delete(String id, String restId,String uid){
    final product = getProduct(id,restId,uid);
    return product == null
        ? false
        : onDelete(product.deleteItem(true));
  }

  @protected
  bool onInsert(ProductCart product) {
    _update(product);
    return true;
  }
  @protected
  bool onIncrement(ProductCart product) {
    _update(product);
    return true;
  }

  @protected
  bool onDelete(ProductCart product){
    _update(product);
    return true;
  }

  bool decrease(String id,String restaurantId,String userId) {
    var product = getProduct(id,restaurantId,userId);
    if (product == null) return false;
    product = product.decrease();
    return product.countProducts <= 0
        ? onRemove(product)
        : onDecrease(product);
  }

  bool remove(String id,String restaurantId,String userId) {
    var product = getProduct(id,restaurantId,userId);
    if (product == null) return false;
    return onRemove(product);
  }
  
  @protected
  bool onDecrease(ProductCart product) {
    _update(product);
    return true;
  }
  @protected
  bool onRemove(ProductCart product) {
    products.remove(product);
    return true;
  }

  _update(ProductCart product) {
    assert(product != null);
    products.remove(product);
    products.add(product);
  }

  Iterable<String> get idProducts => products.map((prod) => prod.id);
  static Cart fromJson(Map json) => _$CartFromJson(json);
  Map<String, dynamic> toJson() => _$CartToJson(this);
}


@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductCart {
  final String id;
  final String restaurantId;
  final int countProducts;
  final String userId;
  final double price;
  final String category;
  final bool delete;

  ProductCart({
    @required this.category,
    @required this.id, this.countProducts: 0,
    @required this.restaurantId,
    @required this.userId,
    @required this.price,
    this.delete=false
  }): assert(countProducts != null), assert(id != null);

  ProductCart decrease() {
    return copyWith(countProducts: countProducts-1);
  }

  ProductCart increment() {
    return copyWith(countProducts: countProducts+1);
  }

  @override
  bool operator ==(o) => o is ProductCart && o.id == id && o.restaurantId==restaurantId && o.userId==userId;

  @override
  int get hashCode => hash(id);

  String toString() => "ProductCart(id: $id, numItemsOrdered: $countProducts, restaurantId: $restaurantId, userId: $userId)";

  ProductCart deleteItem(bool delete){
    return ProductCart(
        id: id,
        restaurantId:restaurantId,
        countProducts: countProducts,
        userId: userId,
        price: price,
        category: category,
        delete: delete
    );
  }

  ProductCart copyWith({int countProducts}) {
    return ProductCart(
      id: id,
      countProducts: countProducts,
      restaurantId: restaurantId,
      userId:userId,
      price:price,
      category: category,
      delete: delete
    );
  }

  static ProductCart fromJson(Map json) => _$ProductCartFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCartToJson(this);
}


abstract class ProductCartPriceRule {
  String get id;
  double get price;
  String get restaurantId;
  String get userId;
  String get category;
  int get countProducts;
}