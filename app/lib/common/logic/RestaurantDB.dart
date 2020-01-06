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
      return query.documents.map((snap) => RestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<RestaurantModel>> getTypeRestaurants(String type) {
    return fs.collection(restaurants.id).where('type', isEqualTo: type).snapshots().map((query) {
      return query.documents.map((snap) => RestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<TypesRestaurantModel>> getTypesRestaurants() {
    return fs.collection(restaurants.types).snapshots().map((query) {
      return query.documents.map((snap) => TypesRestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<RestaurantModel> getRestaurant(String path) {
    return fs.collection(restaurants.id).document(path).snapshots().map(RestaurantModel.fromFirebase);
  }

  Stream<List<ReviewModel>> getReviews(String idRestaurant) {
    return fs.collection(restaurants.id).document(idRestaurant).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }

  Stream<List<ReviewModel>> getDriverReviews(String uid) {
    return fs.collection('users').document(uid).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
