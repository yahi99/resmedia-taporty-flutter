import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoder/model.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/client/model/CartProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinRestaurantProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinUserProvider.dart';
import 'package:resmedia_taporty_flutter/config/Collections.dart';

mixin MixinOrderProvider on MixinUserProvider, MixinRestaurantProvider {
  final orderCollection = Firestore.instance.collection(Collections.ORDERS);

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

  List<OrderProductModel> _getOrderProducts(List<ProductModel> products, List<CartProductModel> cartProducts, String customerId) {
    var orderProducts = List<OrderProductModel>();
    for (var cartProduct in cartProducts) {
      if (cartProduct.quantity <= 0) continue;
      var product = products.firstWhere((p) => p.id == cartProduct.id && customerId == cartProduct.userId);
      if (product != null) {
        orderProducts.add(OrderProductModel(imageUrl: product.imageUrl, quantity: cartProduct.quantity, name: product.name, price: product.price));
      }
    }
    return orderProducts;
  }

  Future<void> createOrder(List<CartProductModel> cartProducts, String customerId, GeoPoint customerCoordinates, String customerAddress, String customerPhone, String restaurantId, String driverId,
      ShiftModel selectedShift, String cardId) async {
    UserModel customer = await getUserById(customerId);
    UserModel driver = await getUserById(driverId);
    RestaurantModel restaurant = await getRestaurant(restaurantId);
    List<ProductModel> products = await getProductList(restaurantId);

    var orderProducts = _getOrderProducts(products, cartProducts, customerId);

    var order = OrderModel(
      customerId: customerId,
      driverId: driverId,
      restaurantId: restaurantId,
      preferredDeliveryTimestamp: selectedShift.endTime,
      productCount: orderProducts.fold(0, (count, product) => count + product.quantity),
      totalPrice: orderProducts.fold(0, (price, product) => price + product.quantity * product.price),
      state: OrderState.NEW,
      customerImageUrl: customer.img,
      customerName: customer.nominative,
      customerCoordinates: customerCoordinates,
      customerAddress: customerAddress,
      customerPhoneNumber: customerPhone,
      driverImageUrl: driver.img,
      driverName: driver.nominative,
      driverPhoneNumber: driver.phoneNumber,
      restaurantImageUrl: restaurant.imageUrl,
      restaurantName: restaurant.name,
      restaurantCoordinates: restaurant.coordinates,
      restaurantAddress: restaurant.address,
      restaurantPhoneNumber: restaurant.phoneNumber,
      cardId: cardId,
      products: orderProducts,
    );

    // TODO: Genera l'id dell'ordine da te
    var documentReference = orderCollection.document();

    await documentReference.setData({...order.toJson(), 'creationTimestamp': FieldValue.serverTimestamp(), 'reference': documentReference});
  }
}
