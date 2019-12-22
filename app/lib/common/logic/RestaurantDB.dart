import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_taporty_flutter/common/logic/Collections.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:resmedia_taporty_flutter/common/model/TypesRestaurantModel.dart';

mixin RestaurantDb implements FirebaseDatabase {
  RestaurantsCollection get restaurants;

  Stream<List<RestaurantModel>> getRestaurants() {
    return fs.collection(restaurants.id).snapshots().map((query) {
      return query.documents
          .map((snap) => RestaurantModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<RestaurantModel>> getTypeRestaurants(String type) {
    return fs
        .collection(restaurants.id)
        .where('type', isEqualTo: type)
        .snapshots()
        .map((query) {
      return query.documents
          .map((snap) => RestaurantModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<TypesRestaurantModel>> getTypesRestaurants() {
    return fs.collection(restaurants.types).snapshots().map((query) {
      return query.documents
          .map((snap) => TypesRestaurantModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<RestaurantModel> getAdminRestaurant(String uid) async* {
    final query = fs
        .collection(restaurants.id)
        .where('$RULES.$uid', isEqualTo: "admin")
        .limit(1)
        .snapshots();
    await for (final snap in query) {
      yield snap.documents.map(RestaurantModel.fromFirebase).first;
    }
  }

  Stream<RestaurantModel> getRestaurant(String path) {
    return fs
        .collection(restaurants.id)
        .document(path)
        .snapshots()
        .map(RestaurantModel.fromFirebase);
  }

  Stream<List<FoodModel>> getFoods(String idRestaurant) {
    return fs
        .collection(restaurants.id)
        .document(idRestaurant)
        .collection(restaurants.$foods.id)
        .where('isDisabled',isEqualTo:false)
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, FoodModel.fromFirebase));
  }

  Stream<List<DrinkModel>> getDrinks(String idRestaurant) {
    return fs
        .collection(restaurants.id)
        .document(idRestaurant)
        .collection(restaurants.$drinks.id)
        .where('isDisabled',isEqualTo:false)
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, DrinkModel.fromFirebase));
  }

  Stream<List<FoodModel>> getFoodsCtrl(String idRestaurant) {
    return fs
        .collection(restaurants.id)
        .document(idRestaurant)
        .collection(restaurants.$foods.id)
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, FoodModel.fromFirebase));
  }

  Stream<List<DrinkModel>> getDrinksCtrl(String idRestaurant) {
    return fs
        .collection(restaurants.id)
        .document(idRestaurant)
        .collection(restaurants.$drinks.id)
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, DrinkModel.fromFirebase));
  }

  Future<void> updateProdDis(ProductModel model,String cat)async{
    print(model.isDisabled);
    if(model.isDisabled==null) await fs.collection('restaurants').document(model.restaurantId).collection(cat).document(model.id).updateData({'isDisabled':false});
  }

  Stream<List<ReviewModel>> getReviews(String idRestaurant) {
    return fs
        .collection(restaurants.id)
        .document(idRestaurant)
        .collection('reviews')
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }

  Stream<List<ReviewModel>> getDriverReviews(String uid) {
    return fs
        .collection('users')
        .document(uid)
        .collection('reviews')
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }

  Future<FoodModel> getFood(String path) async {
    final snap = await fs.document(path).get();
    return FoodModel.fromFirebase(snap);
  }

  Future<DrinkModel> getDrink(String path) async {
    final snap = await fs.document(path).get();
    return DrinkModel.fromFirebase(snap);
  }
}
