import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_blocs/src/cart/Cart.dart';
import 'package:flutter/foundation.dart';


class CartStorage extends Cart {
  final Storage _storage;

  CartStorage({
    List<ProductCart> products: const [],
    @required Storage storage,
  }) : assert(storage != null),
        this._storage = storage, super(products: products);

  @override
  bool increment(String id,String restaurantId,String userId,double price) {
    return _store(super.increment(id,restaurantId,userId,price));
  }

  @override
  bool decrease(String id,String restaurantId,String userId) {
    return _store(super.decrease(id,restaurantId,userId));
  }

  @override
  bool remove(String id,String restaurantId,String userId) {
    return _store(super.remove(id,restaurantId,userId));
  }

  bool _store(bool save) {
    if (save) {
      _storing();
    }
    return save;
  }

  Future<void> _storing() async {
    await _storage.setMap(map: toJson());
  }

  static Future<CartStorage> load({Storage storage}) async {
    final tmpCart = await storage.getObject(fromJson: Cart.fromJson);
    return CartStorage(products: tmpCart?.products??[], storage: storage);
  }
}



