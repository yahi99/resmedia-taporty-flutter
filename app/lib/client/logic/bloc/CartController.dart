import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/client/model/CartStorage.dart';
import 'package:rxdart/rxdart.dart';

class CartController implements CartControllerRule {
  CartController({CartModel cart: const CartModel(), void onListen()}) {
    _cartController.onListen = () {
      _cartController.add(cart);
      if (onListen != null) onListen();
    };
  }
  CartController.storage({
    CartModel cart: const CartModel(),
    @required Storage storage,
    void onListen(),
  }) {
    _cartController.onListen = () async {
      _cartController.add(await CartStorage.load(
        storage: storage,
      ));
      if (onListen != null) onListen();
    };
  }

  void close() {
    _cartController.close();
  }

  final BehaviorSubject<CartModel> _cartController = BehaviorSubject();
  CartModel get _cart => _cartController.value;
  Observable<CartModel> get outCart => _cartController.stream;

  void add(CartModel cart) {
    _cartController.add(cart);
  }

  Future<bool> inIncrement(String id, String restaurantId, String userId, double price, String category) async {
    return _update(_cart.increment(id, restaurantId, userId, price, category));
  }

  Future<bool> inDecrease(String id, String restaurantId, String userId) async {
    return _update(_cart.decrease(id, restaurantId, userId));
  }

  Future<bool> inRemove(String id, String restaurantId, String userId) async {
    return _update(_cart.remove(id, restaurantId, userId));
  }

  bool _update(bool update) {
    if (update) _cartController.add(_cart);
    return update;
  }
}

abstract class CartControllerRule {
  Observable<CartModel> get outCart;

  Future<void> inIncrement(String id, String restaurantId, String userId, double price, String category);

  Future<void> inDecrease(String id, String restaurantId, String userId);

  Future<void> inRemove(String id, String restaurantId, String userId);
}

mixin MixinCartController implements CartControllerRule {
  CartControllerRule get cartController;

  Observable<CartModel> get outCart => cartController.outCart;

  Future<void> inIncrement(String id, String restaurantId, String userId, double price, String category) => cartController.inIncrement(id, restaurantId, userId, price, category);

  Future<void> inDecrease(String id, String restaurantId, String userId) => cartController.inDecrease(id, restaurantId, userId);

  Future<void> inRemove(String id, String restaurantId, String userId) => cartController.inRemove(id, restaurantId, userId);
}
