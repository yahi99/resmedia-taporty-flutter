import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:easy_blocs/src/rxdart_extension/CacheSubject.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';

/// Usa il controller
@deprecated
class BasicCartBloc implements Bloc {
  @protected @override @mustCallSuper
  void dispose() {
    _cartControl.close();
  }

  Cart _cart;

  void init({@required Cart cart}) {
    _cart = cart;
    _save(true);
  }

  CacheSubject<Cart> _cartControl = CacheSubject();
  Stream<Cart> get outCart => _cartControl.stream;

  Future<bool> inIncrement(String id,String restaurantId,String userId,double price,String category) async {
    return _save(_cart.increment(id,restaurantId,userId,price,category));
  }

  Future<bool> inDecrease(String id,String restaurantId,String userId) async {
    return _save(_cart.decrease(id,restaurantId,userId));
  }

  bool _save(bool save) {
    if (save) {
      _cartControl.add(_cart);
    }
    return save;
  }

  void inEnabling(bool isEnable) async {
    _cartControl.add(isEnable ? _cart : null);
  }

  BasicCartBloc.instance();
}