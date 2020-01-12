import 'dart:async';
import 'dart:core';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/CartController.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/client/model/CartProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends Bloc {
  List<FirebaseModel> _resolver(CartModel cart) {
    return null;

    /// Risolve gli id dei prodotti
  }

  final Database _db = Database();

  UserBloc user = UserBloc.of();
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

  Future<List<CartProductModel>> inDeleteCart(String restaurantId) async {
    final cart = await outCart.first;
    final firebaseUser = await user.outFirebaseUser.first;
    var cartProducts = cart.products;
    List<CartProductModel> products = List<CartProductModel>();
    for (int i = 0; i < cartProducts.length; i++) {
      if (cartProducts.elementAt(i).userId == firebaseUser.uid && cartProducts.elementAt(i).restaurantId == restaurantId) {
        products.add(cartProducts.elementAt(i));
      }
    }

    for (int i = 0; i < products.length; i++) {
      _cartController.inRemove(products.elementAt(i).id, restaurantId, firebaseUser.uid);
    }
    return products;
  }

  Future<String> findDriver(ShiftModel selectedShift, String restaurantId, GeoPoint customerCoordinates) async {
    return _db.findDriver(selectedShift, restaurantId, customerCoordinates);
  }

  Future<bool> signer(String restaurantId, String driverId, GeoPoint customerCoordinates, String customerAddress, CheckoutScreenData data) async {
    final userBloc = UserBloc.of();
    final firebaseUser = await userBloc.outUser.first;
    var products = await inDeleteCart(restaurantId);

    await _db.createOrder(products, firebaseUser.model.id, customerCoordinates, customerAddress, data.name, data.phone, restaurantId, driverId, data.selectedShift, data.cardId);

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

  factory CartBloc.of() => $Provider.of<CartBloc>();

  static void close() => $Provider.dispose<CartBloc>();
}
