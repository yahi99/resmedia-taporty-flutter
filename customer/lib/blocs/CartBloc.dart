import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
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
  CartModel get _cart => _cartController.value;
  Stream<CartModel> get outCart => _cartController.stream;

  final BehaviorSubject<String> _customerIdController = BehaviorSubject();
  String get _customerId => _customerIdController.value;

  final BehaviorSubject<String> _supplierIdController = BehaviorSubject();
  String get _supplierId => _supplierIdController.value;

  @override
  void dispose() {
    _cartController.close();
    _customerIdController.close();
    _supplierIdController.close();
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
    _customerIdController.add(customerId);
    _supplierIdController.add(supplierId);

    productSubscription?.cancel();

    if (customerId == null || supplierId == null) return;

    var cart = await _sharedPreferences.getCart(customerId, supplierId);

    var productStream = _db.getProductListStream(supplierId);
    var products = await productStream.first;

    cart.updateWithNewProductList(products);
    _update(cart);

    productSubscription = productStream.listen((products) {
      _cart.updateWithNewProductList(products);
      _update(_cart);
    });
  }

  List<CartProductModel> clearCart() {
    var cartProducts = _cart.products;
    List<CartProductModel> products = List<CartProductModel>();
    for (int i = 0; i < cartProducts.length; i++) {
      products.add(cartProducts.elementAt(i));
    }

    for (int i = 0; i < products.length; i++) {
      _cart.remove(products.elementAt(i).id);
    }

    _update(_cart);

    return products;
  }

  Future<String> findDriver(ShiftModel selectedShift, String supplierId, GeoPoint customerCoordinates) async {
    return _db.findDriver(selectedShift, supplierId, customerCoordinates);
  }

  Future<bool> signer(String customerId, String supplierId, String driverId, GeoPoint customerCoordinates, String customerAddress, CheckoutDataModel data) async {
    assert(customerId == _customerId);
    assert(supplierId == _supplierId);
    var products = clearCart();

    await _db.createOrder(products, customerId, customerCoordinates, customerAddress, data.name, data.phone, supplierId, driverId, data.selectedShift, data.cardId);

    return true;
  }

  void increment(String id) async {
    _cart.increment(id);
    _update(_cart);
  }

  void decrease(String id) async {
    _cart.decrease(id);
    _update(_cart);
  }

  void add(ProductModel product) async {
    _cart.add(product);
    _update(_cart);
  }

  void remove(String id) async {
    _cart.remove(id);
    _update(_cart);
  }

  void _update(CartModel cart) {
    _cartController.add(cart);
    _sharedPreferences.updateCart(_customerId, _supplierId, cart);
  }
}
