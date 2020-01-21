import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_taporty_core/src/blocs/CartController.dart';
import 'package:resmedia_taporty_core/src/models/CartModel.dart';
import 'package:resmedia_taporty_core/src/models/CartProductModel.dart';
import 'package:resmedia_taporty_core/src/models/CheckoutDataModel.dart';
import 'package:resmedia_taporty_core/src/models/ProductModel.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';
import 'package:resmedia_taporty_core/src/resources/Database.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends Bloc {
  List<FirebaseModel> _resolver(CartModel cart) {
    return null;

    /// Risolve gli id dei prodotti
  }

  final Database _db = Database();

  CartController _cartController;

  CartController get cartController => _cartController;

  Stream<CartModel> get outCart => _cartController.outCart;

  final BehaviorSubject<List<ProductModel>> _productController = BehaviorSubject();

  Observable<List<ProductModel>> get outProducts => _productController.stream;

  @override
  void dispose() {
    _cartController.close();
    _productController.close();
  }

  Future<List<CartProductModel>> inDeleteCart(String customerId, String supplierId) async {
    final cart = await outCart.first;
    var cartProducts = cart.products;
    List<CartProductModel> products = List<CartProductModel>();
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts.elementAt(i).userId == customerId && cartProducts.elementAt(i).supplierId == supplierId) {
        products.add(cartProducts.elementAt(i));
      }
    }

    for (int i = 0; i < products.length; i++) {
      _cartController.inRemove(products.elementAt(i).id, supplierId, customerId);
    }
    return products;
  }

  Future<String> findDriver(ShiftModel selectedShift, String supplierId, GeoPoint customerCoordinates) async {
    return _db.findDriver(selectedShift, supplierId, customerCoordinates);
  }

  Future<bool> signer(String customerId, String supplierId, String driverId, GeoPoint customerCoordinates, String customerAddress, CheckoutDataModel data) async {
    var products = await inDeleteCart(customerId, supplierId);

    await _db.createOrder(products, customerId, customerCoordinates, customerAddress, data.name, data.phone, supplierId, driverId, data.selectedShift, data.cardId);

    return true;
  }

  CartBloc.instance() {
    _cartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Products")),
    );
    _productController.onListen = () {
      _cartController.outCart.listen((cart) {
        _productController.add(_resolver(cart));
      });
    };
  }
}
