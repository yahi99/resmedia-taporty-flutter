import 'dart:async';
import 'dart:core';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/interface/screen/RestaurantScreen.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';

/// Uso sconsigliato, implementa in un tuo Bloc il [CartFirestore]
/// Esempio di un Cart con implementazione di storage, non di salvataggio in cloud
/// Drinks e Foods come prodotti
class CartBloc extends Bloc {
  List<FirebaseModel> _resolver(Cart cart) {
    return null;

    /// Risolve gli id dei prodotti
  }

  final Database _db = Database();

  final Hand _hand = Hand();
  final FormHandler _formHandler = FormHandler();

  UserBloc user = UserBloc.of();
  CartController _foodsCartController;
  CartControllerRule get foodsCartController => _foodsCartController;
  Stream<Cart> get outFoodsCart => _foodsCartController.outCart;

  /// Sostituire con il Model appropriato
  final BehaviorSubject<List<FoodModel>> _foodsController = BehaviorSubject();
  Observable<List<FoodModel>> get outFoods => _foodsController.stream;

  CartController _drinksCartController;
  CartControllerRule get drinksCartController => _drinksCartController;
  Stream<Cart> get outDrinksCart => _drinksCartController.outCart;

  /// Sostituire con il Model appropriato
  final BehaviorSubject<List<DrinkModel>> _drinksController = BehaviorSubject();
  Observable<List<DrinkModel>> get outDrinks => _drinksController.stream;

  SubmitController _submitController;
  SubmitController get submitController => _submitController;

  @override
  void dispose() {
    _foodsCartController.close();
    _foodsController.close();
    _drinksCartController.close();
    _drinksController.close();
    _hand.dispose();
    _formHandler.dispose();
  }

  Future<Cart> inDeleteCart(String restaurantId) async {
    final food = await outFoodsCart.first;
    final drink = await outDrinksCart.first;
    final firebaseUser = await user.outFirebaseUser.first;
    var temp = food.products;
    List<ProductCart> products=new List<ProductCart>();
    for (int i = 0; i < temp.length; i++) {
      if (temp.elementAt(i).userId == firebaseUser.uid &&
          temp.elementAt(i).restaurantId == restaurantId) {
        products.add(temp.elementAt(i));
        _foodsCartController.inRemove(temp.elementAt(i).id, restaurantId, firebaseUser.uid);
      }
    }
    temp = drink.products;
    for (int i = 0; i < temp.length; i++) {
      if (temp.elementAt(i).userId == firebaseUser.uid &&
          temp.elementAt(i).restaurantId == restaurantId) {
        products.add(temp.elementAt(i));
        _drinksCartController.inRemove(temp.elementAt(i).id, restaurantId, firebaseUser.uid);
      }
    }
    var cart = new Cart(products: products);
    return cart;
  }

  Future<void> inIncrementDrink(ProductModel model) async {
    return CacheStreamBuilder<FirebaseUser>(
        stream: user.outFirebaseUser,
        builder: (context, snap) {
          if (snap.hasData) {
            _drinksCartController.inIncrement(model.id, model.restaurantId,
                snap.data.uid, double.parse(model.price));
          }
        });
  }

  /*Future<void> inRemoveDrink(ProductModel model) async {
    return CacheStreamBuilder<FirebaseUser>(
        stream: user.outFirebaseUser,
        builder: (context, snap)
        {
          if (snap.hasData) {
            _drinksCartController.inRemove(
                model.id, model.restaurantId, snap.data.uid);
          }
        }
    );
  }*/

  Future<void> inDecrementDrink(ProductModel model) async {
    return CacheStreamBuilder<FirebaseUser>(
        stream: user.outFirebaseUser,
        builder: (context, snap) {
          if (snap.hasData) {
            _drinksCartController.inDecrease(
                model.id, model.restaurantId, snap.data.uid);
          }
        });
  }

  Future<String> isAvailable(String date, String time)async{
    final model= await _db.getUsers(date,time);
    if(model.free.length>1){
      final temp=model.free;
      final user=temp.removeAt(1);
      final occ=model.occupied;
      occ.add(user);
      await _db.occupyDriver(date,time,temp,occ);
      return user;
    }
    return null;
  }

  Future<bool> signer(String restaurantId,String driver,Position userPos,String userAddress,String startTime,String endTime) async {
    final userBloc = UserBloc.of();
    final firebaseUser = await userBloc.outUser.first;
    inDeleteCart(restaurantId).then((cart){
      _db.createOrder(uid: firebaseUser.model.id, model: cart,driver:driver,userPos: userPos,addressR: userAddress,startTime: startTime,nominative: firebaseUser.model.nominative,endTime: endTime);
      RestaurantScreen.isOrdered=true;
    });

    return true;
  }

  /*void setSigner(String restaurantId){
    _submitController = SubmitController(
        onSubmit: () => signer(restaurantId),
        handler: _formHandler,
        hand: _hand);
  }*/

  CartBloc.instance() {
    _foodsCartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Foods")),
    );
    _foodsController.onListen = () {
      _foodsCartController.outCart.listen((cart) {
        _foodsController.add(_resolver(cart));
      });
    };
    _drinksCartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Drink")),
    );
    _drinksController.onListen = () {
      _drinksCartController.outCart.listen((cart) {
        _drinksController.add(_resolver(cart));
      });
    };
  }
  factory CartBloc.of() => $Provider.of<CartBloc>();
  static void close() => $Provider.dispose<CartBloc>();
}
