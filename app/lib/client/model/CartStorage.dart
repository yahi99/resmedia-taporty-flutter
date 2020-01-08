import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/client/model/CartProductModel.dart';

// TODO: In futuro rimuovi e sposta la logica nel CartBloc
class CartStorage extends CartModel {
  final Storage _storage;

  CartStorage({
    List<CartProductModel> products: const [],
    @required Storage storage,
  })  : assert(storage != null),
        this._storage = storage,
        super(products: products);

  @override
  bool increment(String id, String restaurantId, String userId, double price, String category) {
    return _store(super.increment(id, restaurantId, userId, price, category));
  }

  @override
  bool decrease(String id, String restaurantId, String userId) {
    return _store(super.decrease(id, restaurantId, userId));
  }

  @override
  bool remove(String id, String restaurantId, String userId) {
    return _store(super.remove(id, restaurantId, userId));
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
    final tmpCart = await storage.getObject(fromJson: CartModel.fromJson);
    return CartStorage(products: tmpCart?.products ?? [], storage: storage);
  }
}