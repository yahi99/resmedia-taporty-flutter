import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:resmedia_taporty_flutter/config/Collections.dart';

mixin MixinRestaurantProvider {
  final restaurantCollection = Firestore.instance.collection(Collections.RESTAURANTS);

  Stream<List<RestaurantModel>> getRestaurantListStream() {
    return restaurantCollection.snapshots().map((query) {
      return query.documents.map((snap) => RestaurantModel.fromFirebase(snap)).toList();
    });
  }

  Stream<RestaurantModel> getRestaurantStream(String restaurantId) {
    return restaurantCollection.document(restaurantId).snapshots().map(RestaurantModel.fromFirebase);
  }

  Future<RestaurantModel> getRestaurant(String restaurantId) async {
    return RestaurantModel.fromFirebase(await restaurantCollection.document(restaurantId).get());
  }

  Future<List<ProductModel>> getProductList(String restaurantId) async {
    return (await restaurantCollection.document(restaurantId).collection(Collections.PRODUCTS).where('state', isEqualTo: "ACCEPTED").getDocuments())
        .documents
        .map((querySnap) => ProductModel.fromFirebase(querySnap))
        .toList();
  }

  Stream<List<ProductModel>> getProductListStream(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getFoodListStream(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED") // ACCEPTED
        .where('type', isEqualTo: "food")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getDrinkListStream(String restaurantId) {
    return restaurantCollection
        .document(restaurantId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED") // ACCEPTED
        .where('type', isEqualTo: "drink")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ReviewModel>> getReviewListStream(String restaurantId) {
    return restaurantCollection.document(restaurantId).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
