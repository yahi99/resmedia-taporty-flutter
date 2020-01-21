import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_core/src/models/CartModel.dart';
import 'package:resmedia_taporty_core/src/models/CartProductModel.dart';

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
  bool increment(String id, String supplierId, String userId, double price, String category) {
    return _store(super.increment(id, supplierId, userId, price, category));
  }

  @override
  bool decrease(String id, String supplierId, String userId) {
    return _store(super.decrease(id, supplierId, userId));
  }

  @override
  bool remove(String id, String supplierId, String userId) {
    return _store(super.remove(id, supplierId, userId));
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
