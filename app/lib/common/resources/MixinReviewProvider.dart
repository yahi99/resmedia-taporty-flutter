import 'package:resmedia_taporty_flutter/common/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinOrderProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinRestaurantProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinUserProvider.dart';

mixin MixinReviewProvider on MixinRestaurantProvider, MixinUserProvider, MixinOrderProvider {
  Future addRestaurantReview(String restId, String userId, String orderId, double rating, String description) async {
    await restaurantCollection.document(restId).collection('reviews').document(orderId).setData({
      'rating': rating,
      'userId': userId,
      'orderId': orderId,
      'description': description,
      'timestamp': datetimeToJson(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasRestaurantReview': true});
  }

  Future addDriverReview(String driverId, String userId, String orderId, double rating, String description) async {
    await userCollection.document(driverId).collection('reviews').document(orderId).setData({
      'rating': rating,
      'userId': userId,
      'orderId': orderId,
      'description': description,
      'timestamp': datetimeToJson(DateTime.now()),
    });
    await orderCollection.document(orderId).updateData({'hasDriverReview': true});
  }
}
