import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';

class RestaurantProvider {
  final restaurantCollection = Firestore.instance.collection("restaurants");

  Stream<List<RestaurantModel>> getRestaurants() {
    return restaurantCollection.snapshots().map((query) {
      return query.documents
          .map((snap) => RestaurantModel.fromFirebase(snap))
          .toList();
    });
  }
}
