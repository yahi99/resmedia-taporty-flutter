import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/cart/CartFirebase.dart';
import 'package:meta/meta.dart';
import 'package:rxdart/rxdart.dart';


abstract class CartFsManager implements CartControllerRule {

  Future<bool> inIncrementFs(ProductCart model);

  Future<bool> inDecreaseFs(ProductCart model);

  Future<bool> inRemoveFs(ProductCart model);
}


class CartFsController with MixinCartControllerFs implements CartFsManager, CartController {
  CartFirestore get _cart => _cartController.value;

  CartFsController({
    CartFirestore cart,
  }) : this._cartController = BehaviorSubject.seeded(cart);

  void setSource({@required Function source, @required ProductCartFirebaseUpdater updater}) {
    StreamSubscription productsSub;
    _cartController.onListen = () async {
      final raw = source();
      productsSub = (raw is Future ? await raw : raw).listen((products) {
        _cartController.add(CartFirestore(products: products, updater: updater));
      });
    };
    _cartController.onCancel = () => productsSub?.cancel();
  }

  void close() {
    _cartController.close();
  }

  final BehaviorSubject<Cart> _cartController;
  @override
  Observable<Cart> get outCart => _cartController.stream;

  @override
  Future<bool> inDecrease(String id,String restaurantId,String userId) async {
    return _cart.decrease(id,restaurantId,userId);
  }

  @override
  Future<bool> inIncrement(String id,String restaurantId,String userId,double price,String category) async {
    return _cart.increment(id,restaurantId,userId,price,category);
  }

  @override
  Future<bool> inRemove(String id,String restaurantId,String userId) async {
    return _cart.remove(id,restaurantId,userId);
  }

  @override
  void add(Cart cart) {
    _cartController.add(cart);
  }
}


/// Aggiunge delle ottimizzazioni per il CartController se è l'unico
mixin MixinCartControllerFs implements CartFsManager {
  Future<bool> inIncrementFs(ProductCart model) {
    return inIncrement(model.id,model.restaurantId,model.userId,model.price,model.category);
  }

  Future<bool> inDecreaseFs(ProductCart model) {
    return inDecrease(model.id,model.restaurantId,model.userId);
  }

  Future<bool> inRemoveFs(ProductCart model) {
    return inDecrease(model.id,model.restaurantId,model.userId);
  }
}