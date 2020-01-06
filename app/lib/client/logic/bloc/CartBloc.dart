import 'dart:async';
import 'dart:core';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';

class CartBloc extends Bloc {
  List<FirebaseModel> _resolver(Cart cart) {
    return null;

    /// Risolve gli id dei prodotti
  }

  final Database _db = Database();

  final Hand _hand = Hand();
  final FormHandler _formHandler = FormHandler();

  UserBloc user = UserBloc.of();
  CartController _productsCartController;

  CartControllerRule get productsCartController => _productsCartController;

  Stream<Cart> get outProductsCart => _productsCartController.outCart;

  final BehaviorSubject<List<ProductModel>> _productController = BehaviorSubject();

  Observable<List<ProductModel>> get outProducts => _productController.stream;

  SubmitController _submitController;

  SubmitController get submitController => _submitController;

  @override
  void dispose() {
    _productsCartController.close();
    _productController.close();
    _hand.dispose();
    _formHandler.dispose();
  }

  Future<Cart> inDeleteCart(String restaurantId) async {
    final cart = await outProductsCart.first;
    final firebaseUser = await user.outFirebaseUser.first;
    var temp = cart.products;
    List<ProductCart> products = List<ProductCart>();
    for (int i = 0; i < temp.length; i++) {
      if (temp.elementAt(i).userId == firebaseUser.uid && temp.elementAt(i).restaurantId == restaurantId) {
        products.add(temp.elementAt(i));
      }
    }

    for (int i = 0; i < products.length; i++) {
      _productsCartController.inRemove(products.elementAt(i).id, restaurantId, firebaseUser.uid);
    }
    return Cart(products: products);
  }

  Future<String> isAvailable(String date, String time, String restId) async {
    final model = await _db.getDrivers(date, time);
    if (model.free.length > 1) {
      final temp = model.free;
      final user = temp.removeAt(1);
      final occ = model.occupied;
      occ.add(user);
      await _db.occupyDriver(date, time, temp, occ, restId, user);
      return user;
    }
    return null;
  }

  Future<bool> signer(
      String restaurantId, String driver, Position userPos, String phone, String userAddress, String startTime, String endTime, String fingerprint, String day, String nominative) async {
    final userBloc = UserBloc.of();
    final firebaseUser = await userBloc.outUser.first;
    inDeleteCart(restaurantId).then((cart) async {
      _db.createOrder(
          phone: phone,
          day: day,
          uid: firebaseUser.model.id,
          model: cart,
          driver: driver,
          userPos: userPos,
          addressR: userAddress,
          startTime: startTime,
          nominative: nominative,
          endTime: endTime,
          fingerprint: fingerprint,
          restAdd: (await Geocoder.local.findAddressesFromCoordinates((await Database().getRestaurantPosition(restaurantId)))).first.addressLine);
      RestaurantScreen.isOrdered = true;
    });

    return true;
  }

  CartBloc.instance() {
    _productsCartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Products")),
    );
    _productController.onListen = () {
      _productsCartController.outCart.listen((cart) {
        _productController.add(_resolver(cart));
      });
    };
  }

  factory CartBloc.of() => $Provider.of<CartBloc>();

  static void close() => $Provider.dispose<CartBloc>();
}
