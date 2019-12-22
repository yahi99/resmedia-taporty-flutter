import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';

typedef void ProductCartFirebaseUpdater(String productId, valuesOrDelete);

/// Per Cart di Modelli salvati in cloud
class CartFirestore extends Cart {
  final ProductCartFirebaseUpdater updater;

  const CartFirestore({
    List<ProductCart> products: const [],
    @required this.updater,
  }) : assert(updater != null), super(products: products);

  @override
  bool onInsert(ProductCart product) {
    _update(product);
    return false;
  }

  @override
  bool onIncrement(ProductCart product) {
    _update(product);
    return false;
  }

  @override
  bool onDecrease(ProductCart product) {
    _update(product);
    return false;
  }

  @override
  bool onRemove(ProductCart product) {
    updater(product.id, FieldValue.delete());
    return false;
  }

  _update(ProductCart product) {
    updater(product.id, product.toJson()..remove('id'));
  }
}
