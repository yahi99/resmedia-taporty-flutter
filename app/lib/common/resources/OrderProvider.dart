import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class OrderProvider {
  final orderCollection = Firestore.instance.collection("orders");

  Stream<List<OrderModel>> getUserOrders(String uid) {
    final data = orderCollection.where("customerId", isEqualTo: uid).snapshots();

    return data.map((query) {
      return query.documents.map((snap) {
        var order = OrderModel.fromFirebase(snap);
        return order;
      }).toList();
    });
  }

  Stream<List<OrderModel>> getDriverOrders(String uid) {
    final data = orderCollection.where("driverId", isEqualTo: uid).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => OrderModel.fromFirebase(snap)).toList();
    });
  }
}
