import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';

class RestaurantProvider {
  final restaurantCollection = Firestore.instance.collection("restaurants");

  Stream<List<RestaurantModel>> getRestaurants() {
    return restaurantCollection.snapshots().map((query) {
      return query.documents.map((snap) => RestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<RestaurantModel> getRestaurant(String path) {
    return restaurantCollection.document(path).snapshots().map(RestaurantModel.fromFirebase);
  }

  Stream<List<ProductModel>> getProducts(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection("products")
        .where('state', isEqualTo: 1) // ACCEPTED
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getFoods(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection("products")
        .where('state', isEqualTo: 1) // ACCEPTED
        .where('type', isEqualTo: "food")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getDrinks(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection("products")
        .where('state', isEqualTo: 1) // ACCEPTED
        .where('type', isEqualTo: "drink")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }
}
