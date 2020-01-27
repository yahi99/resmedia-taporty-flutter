import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends Bloc {
  final DatabaseService _db = DatabaseService();
  final SharedPreferenceService _sharedPreferences = SharedPreferenceService();

  final BehaviorSubject<CartModel> _cartController = BehaviorSubject();
  Stream<CartModel> get outCart => _cartController.stream;

  final BehaviorSubject<String> _customerIdController = BehaviorSubject();
  Stream<String> get outCustomerId => _customerIdController.stream;

  final BehaviorSubject<String> _supplierIdController = BehaviorSubject();
  Stream<String> get outSupplierId => _supplierIdController.stream;

  @override
  void dispose() {
    _cartController.close();
    _customerIdController.close();
    _supplierIdController.close();
  }

  CartBloc.instance();

  StreamSubscription productSubscription;
  Future loadCart(String customerId, String supplierId) async {
    var cart = await _sharedPreferences.getCart(customerId, supplierId);
    _customerIdController.add(customerId);
    _supplierIdController.add(supplierId);

    var productStream = _db.getProductListStream(supplierId);
    var products = await productStream.first;

    cart.updateWithNewProductList(products);
    _update(cart);

    productSubscription?.cancel();
    productSubscription = productStream.listen((products) async {
      var cart = await outCart.first;
      cart.updateWithNewProductList(products);
      _update(cart);
    });
  }

  Future<List<CartProductModel>> clearCart() async {
    final cart = await outCart.first;
    var cartProducts = cart.products;
    List<CartProductModel> products = List<CartProductModel>();
    for (int i = 0; i < cartProducts.length; i++) {
      products.add(cartProducts.elementAt(i));
    }

    for (int i = 0; i < products.length; i++) {
      cart.remove(products.elementAt(i).id);
    }

    await _update(cart);

    return products;
  }

  Future<String> findDriver(ShiftModel selectedShift, String supplierId, GeoPoint customerCoordinates) async {
    return _db.findDriver(selectedShift, supplierId, customerCoordinates);
  }

  Future<bool> signer(String customerId, String supplierId, String driverId, GeoPoint customerCoordinates, String customerAddress, CheckoutDataModel data) async {
    assert(customerId == await outCustomerId.first);
    assert(supplierId == await outSupplierId.first);
    var products = await clearCart();

    await _db.createOrder(products, customerId, customerCoordinates, customerAddress, data.name, data.phone, supplierId, driverId, data.selectedShift, data.cardId);

    return true;
  }

  Future increment(String id, double price, String category) async {
    var cart = await outCart.first;
    cart.increment(id, price, category);
    await _update(cart);
  }

  Future decrease(String id) async {
    var cart = await outCart.first;
    cart.decrease(id);
    await _update(cart);
  }

  Future remove(String id) async {
    var cart = await outCart.first;
    cart.remove(id);
    await _update(cart);
  }

  Future _update(CartModel cart) async {
    _cartController.add(cart);
    _sharedPreferences.updateCart(await outCustomerId.first, await outSupplierId.first, cart);
  }
}
