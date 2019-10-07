import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';


class CartController implements CartControllerRule {

  CartController({Cart cart: const Cart(), void onListen()}) {
    _cartController.onListen = () {
      _cartController.add(cart);
      if (onListen != null) onListen();
    };
  }
  CartController.storage({
    Cart cart: const Cart(), @required Storage storage,
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

  final BehaviorSubject<Cart> _cartController = BehaviorSubject();
  Cart get _cart => _cartController.value;
  Observable<Cart> get outCart => _cartController.stream;

  void add(Cart cart) {
    _cartController.add(cart);
  }

  Future<bool> inIncrement(String id,String restaurantId,String userId,double price,String category) async {
    return _update(_cart.increment(id,restaurantId,userId,price,category));
  }

  Future<bool> inDecrease(String id,String restaurantId,String userId) async {
    return _update(_cart.decrease(id,restaurantId,userId));
  }

  Future<bool> inRemove(String id,String restaurantId,String userId) async {
    return _update(_cart.remove(id,restaurantId,userId));
  }

  bool _update(bool update) {
    if (update)
      _cartController.add(_cart);
    return update;
  }
}


abstract class CartControllerRule {

  Observable<Cart> get outCart;

  Future<void> inIncrement(String id,String restaurantId,String userId,double price,String category);

  Future<void> inDecrease(String id,String restaurantId,String userId);

  Future<void> inRemove(String id,String restaurantId,String userId);
}


mixin MixinCartController implements CartControllerRule {
  CartControllerRule get cartController;

  Observable<Cart> get outCart => cartController.outCart;

  Future<void> inIncrement(String id,String restaurantId,String userId,double price,String category) => cartController.inIncrement(id,restaurantId,userId,price,category);

  Future<void> inDecrease(String id,String restaurantId,String userId) => cartController.inDecrease(id,restaurantId,userId);

  Future<void> inRemove(String id,String restaurantId,String userId) => cartController.inRemove(id,restaurantId,userId);
}

/// Vedi [CartStorage]
/*class StorageCartController extends CartController {
  final Storage storage;

  StorageCartController({
    Cart tmpCart, @required this.storage,
  }) : assert(storage != null), super(cart: tmpCart??[]) {
    storage.getObject(fromJson: Cart.fromJson, ).then((cart) {
      _cartController.add(cart);
    });
  }


  Future<bool> inIncrement(String id) async {
    return await _storage(await super.inIncrement(id));
  }

  Future<bool> inDecrease(String id) async {
    return await _storage(await super.inDecrease(id));
  }

  Future<bool> _storage(bool update) async {
    if (update) {
      storage.setMap(map: _cart.toJson());
    }
    return update;
  }
}*/