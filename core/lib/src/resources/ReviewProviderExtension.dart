import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';

extension ReviewProviderExtension on DatabaseService {
  Stream<ReviewModel> getSupplierReviewStream(String supplierId, String orderId) {
    return supplierCollection.document(supplierId).collection("reviews").document(orderId).snapshots().map((snap) => ReviewModel.fromFirebase(snap));
  }

  Stream<ReviewModel> getDriverReviewStream(String driverId, String orderId) {
    return driverCollection.document(driverId).collection("reviews").document(orderId).snapshots().map((snap) => ReviewModel.fromFirebase(snap));
  }

  Future setSupplierReview(String supplierId, String userId, String customerName, String orderId, double rating, String description) async {
    await supplierCollection.document(supplierId).collection('reviews').document(orderId).setData({
      ...ReviewModel(
        rating: rating,
        userId: userId,
        orderId: orderId,
        description: description,
        customerName: customerName,
      ).toJson(),
      'timestamp': datetimeToTimestamp(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasSupplierReview': true});
  }

  Future setDriverReview(String driverId, String userId, String customerName, String orderId, double rating, String description) async {
    await driverCollection.document(driverId).collection('reviews').document(orderId).setData({
      ...ReviewModel(
        rating: rating,
        userId: userId,
        orderId: orderId,
        description: description,
        customerName: customerName,
      ).toJson(),
      'timestamp': datetimeToTimestamp(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasDriverReview': true});
  }
}
