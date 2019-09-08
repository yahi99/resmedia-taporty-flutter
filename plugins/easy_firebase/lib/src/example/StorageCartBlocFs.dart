import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/database/Models.dart';
import 'package:rxdart/rxdart.dart';

/// Uso sconsigliato, implementa in un tuo Bloc il [CartFirestore]
/// Esempio di un Cart con implementazione di storage, non di salvataggio in cloud
/// Drinks e Foods come prodotti
class _StorageCartBlocFs extends Bloc {

  _StorageCartBlocFs() {
    _foodsCartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Foods")),
    );
    _foodsController = PublishSubject(
      onListen: () {
        _foodsCartController.outCart.listen((cart) {
          _foodsController.add(_resolver(cart));
        });
      },
    );
    _drinksCartController = CartController.storage(
      storage: InternalStorage.manager(versionManager: VersionManager("Drink")),
    );
    _drinksController = PublishSubject(
      onListen: () {
        _drinksCartController.outCart.listen((cart) {
          _drinksController.add(_resolver(cart));
        });
      },
    );
  }

  List<FirebaseModel> _resolver(Cart cart) {
    return null; /// Risolve gli id dei prodotti
  }

  CartController _foodsCartController;
  CartControllerRule get foodsCartController => _foodsCartController;
  Stream<Cart> get outFoodsCart => _foodsCartController.outCart;
  /// Sostituire con il Model appropriato
  PublishSubject<List<FirebaseModel>> _foodsController;
  Observable<List<FirebaseModel>> get outFoods => _foodsController.stream;

  CartController _drinksCartController;
  CartControllerRule get drinksCartController => _drinksCartController;
  Stream<Cart> get outDrinksCart => _drinksCartController.outCart;
  /// Sostituire con il Model appropriato
  PublishSubject<List<FirebaseModel>> _drinksController;
  Observable<List<FirebaseModel>> get outDrinks => _drinksController.stream;

  @override
  void dispose() {
    _foodsCartController.close();
    _foodsController.close();
    _drinksCartController.close();
    _drinksController.close();
  }

  Future<void> inDrink(FirebaseModel model) async {
    _drinksCartController.inIncrement(model.id);
  }
  /// Ec...
}