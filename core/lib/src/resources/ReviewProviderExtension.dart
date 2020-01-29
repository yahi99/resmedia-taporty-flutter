import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';

extension ReviewProviderExtension on DatabaseService {
  Future addSupplierReview(String restId, String userId, String customerName, String orderId, double rating, String description) async {
    await supplierCollection.document(restId).collection('reviews').document(orderId).setData({
      'rating': rating,
      'userId': userId,
      'orderId': orderId,
      'description': description,
      'customerName': customerName,
      'timestamp': datetimeToJson(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasSupplierReview': true});
  }

  Future addDriverReview(String driverId, String userId, String customerName, String orderId, double rating, String description) async {
    await userCollection.document(driverId).collection('reviews').document(orderId).setData({
      'rating': rating,
      'userId': userId,
      'orderId': orderId,
      'description': description,
      'customerName': customerName,
      'timestamp': datetimeToJson(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasDriverReview': true});
  }
}
