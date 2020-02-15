import 'dart:async';
import 'dart:core';
import 'package:dash/dash.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/SupplierBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends Bloc {
  final DatabaseService _db = DatabaseService();
  final userBloc = $Provider.of<UserBloc>();
  final supplierBloc = $Provider.of<SupplierBloc>();
  final SharedPreferenceService _sharedPreferences = SharedPreferenceService();

  final BehaviorSubject<CartModel> _cartController = BehaviorSubject();
  CartModel get cart => _cartController.value;
  Stream<CartModel> get outCart => _cartController.stream;

  @override
  void dispose() {
    _cartController.close();
  }

  CartBloc.instance() {
    userBloc.outUser.listen((user) => loadCart());
    supplierBloc.outSupplierId.listen((supplierId) => loadCart());
  }

  StreamSubscription productSubscription;
  Future loadCart() async {
    var customerId = userBloc.user?.id;
    var supplierId = supplierBloc.supplierId;

    if (customerId == null || supplierId == null) return;
    productSubscription?.cancel();

    if (customerId == null || supplierId == null) return;

    var storedCart = await _sharedPreferences.getCart(customerId, supplierId);

    var productStream = _db.getProductListStream(supplierId);
    var products = await productStream.first;

    storedCart.updateWithNewProductList(products);
    _update(storedCart);

    productSubscription = productStream.listen((products) {
      cart.updateWithNewProductList(products);
      _update(cart);
    });
  }

  List<CartProductModel> clearCart() {
    var cartProducts = cart.products;
    List<CartProductModel> products = List<CartProductModel>();
    for (int i = 0; i < cartProducts.length; i++) {
      products.add(cartProducts.elementAt(i));
    }

    for (int i = 0; i < products.length; i++) {
      cart.remove(products.elementAt(i).id);
    }

    _update(cart);

    return products;
  }

  void increment(String id) async {
    cart.increment(id);
    _update(cart);
  }

  void decrease(String id) async {
    cart.decrease(id);
    _update(cart);
  }

  void add(ProductModel product) async {
    cart.add(product);
    _update(cart);
  }

  void remove(String id) async {
    cart.remove(id);
    _update(cart);
  }

  void _update(CartModel updatedCart) {
    _cartController.add(updatedCart);
    var customerId = userBloc.user.id;
    var supplierId = supplierBloc.supplierId;
    _sharedPreferences.updateCart(customerId, supplierId, updatedCart);
  }
}
