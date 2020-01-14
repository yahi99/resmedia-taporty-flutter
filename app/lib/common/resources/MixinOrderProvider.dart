import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_flutter/client/model/CartProductModel.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeSerialization.dart';
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

  Stream<OrderModel> getOrderStream(String orderId) {
    return orderCollection.document(orderId).snapshots().map((snap) => OrderModel.fromFirebase(snap));
  }

  Stream<List<OrderModel>> getUserOrdersStream(String uid) {
    final data = orderCollection.where("customerId", isEqualTo: uid).orderBy("creationTimestamp", descending: true).snapshots();

    return data.map((query) {
      return query.documents.map((snap) {
        var order = OrderModel.fromFirebase(snap);
        return order;
      }).toList();
    });
  }

  Stream<List<OrderModel>> getDriverOrdersStream(String uid) {
    final data = orderCollection.where("driverId", isEqualTo: uid).orderBy("creationTimestamp", descending: true).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => OrderModel.fromFirebase(snap)).toList();
    });
  }

  List<OrderProductModel> _getOrderProducts(List<ProductModel> products, List<CartProductModel> cartProducts, String customerId) {
    var orderProducts = List<OrderProductModel>();
    for (var cartProduct in cartProducts) {
      if (cartProduct.quantity <= 0) continue;
      var product = products.firstWhere((p) => p.id == cartProduct.id && customerId == cartProduct.userId, orElse: () => null);
      if (product != null) {
        orderProducts.add(OrderProductModel(id: product.id, imageUrl: product.imageUrl, quantity: cartProduct.quantity, name: product.name, price: product.price));
      }
    }
    return orderProducts;
  }

  Future<void> createOrder(List<CartProductModel> cartProducts, String customerId, GeoPoint customerCoordinates, String customerAddress, String customerName, String customerPhone, String restaurantId,
      String driverId, ShiftModel selectedShift, String cardId) async {
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
      customerImageUrl: customer.imageUrl,
      customerName: customerName,
      customerCoordinates: customerCoordinates,
      customerAddress: customerAddress,
      customerPhoneNumber: customerPhone,
      driverImageUrl: driver.imageUrl,
      driverName: driver.nominative,
      driverPhoneNumber: driver.phoneNumber,
      restaurantImageUrl: restaurant.imageUrl,
      restaurantName: restaurant.name,
      restaurantCoordinates: restaurant.coordinates,
      restaurantAddress: restaurant.address,
      restaurantPhoneNumber: restaurant.phoneNumber,
      cardId: cardId,
      creationTimestamp: DateTime.now(),
      products: orderProducts,
    );

    // TODO: Genera l'id dell'ordine da te
    var documentReference = orderCollection.document();

    await documentReference.setData({...order.toJson(), 'reference': documentReference});
  }

  // TODO: Da mettere dentro una Transaction
  Future<void> modifyOrder(String orderId, OrderState prevState, List<OrderProductModel> orderProducts) async {
    orderProducts = orderProducts.where((o) => o.quantity > 0).toList();

    if (prevState == OrderState.NEW) {
      var order = await getOrderStream(orderId).first;

      var newOrder = OrderModel(
        productCount: orderProducts.fold(0, (count, product) => count + product.quantity),
        totalPrice: orderProducts.fold(0, (price, product) => price + product.quantity * product.price),
        products: orderProducts,
        preferredDeliveryTimestamp: order.preferredDeliveryTimestamp,
        creationTimestamp: DateTime.now(),
        customerName: order.customerName,
        customerCoordinates: order.customerCoordinates,
        customerAddress: order.customerAddress,
        customerPhoneNumber: order.customerPhoneNumber,
        customerImageUrl: order.customerImageUrl,
        restaurantName: order.restaurantName,
        restaurantCoordinates: order.restaurantCoordinates,
        restaurantAddress: order.restaurantAddress,
        restaurantPhoneNumber: order.restaurantPhoneNumber,
        restaurantImageUrl: order.restaurantImageUrl,
        driverName: order.driverName,
        driverPhoneNumber: order.driverPhoneNumber,
        driverImageUrl: order.driverImageUrl,
        restaurantId: order.restaurantId,
        driverId: order.driverId,
        customerId: order.customerId,
        state: OrderState.NEW,
        cardId: order.cardId,
      );

      var documentReference = orderCollection.document();

      await documentReference.setData({...newOrder.toJson(), 'reference': documentReference, 'oldOrderId': order.id});

      await orderCollection.document(orderId).updateData({
        'state': orderStateEncode(OrderState.ARCHIVED),
        'archiviationTimestamp': datetimeToJson(DateTime.now()),
        'newOrderId': documentReference.documentID,
      });
    } else if (prevState == OrderState.ACCEPTED || prevState == OrderState.READY) {
      await orderCollection.document(orderId).updateData({
        'state': orderStateEncode(OrderState.MODIFIED),
        'prevState': prevState,
        'modificationTimestamp': datetimeToJson(DateTime.now()),
        'newProductCount': orderProducts.fold(0, (count, product) => count + product.quantity),
        'newTotalPrice': orderProducts.fold(0, (price, product) => price + product.quantity * product.price),
        'newProducts': orderProducts.map((o) => o.toJson()).toList(),
      });
    }
  }

  Future updateOrderState(String orderId, OrderState state) async {
    var timestampField;
    switch (state) {
      case OrderState.CANCELLED:
        timestampField = "cancellationTimestamp";
        break;
      case OrderState.PICKED_UP:
        timestampField = "pickupTimestamp";
        break;
      case OrderState.DELIVERED:
        timestampField = "deliveryTimestamp";
        break;
      default:
        return;
    }
    var document = orderCollection.document(orderId);
    bool error = false;
    await Firestore.instance.runTransaction((Transaction tx) async {
      var order = OrderModel.fromFirebase(await tx.get(document));
      if (state == OrderState.CANCELLED && (order.state != OrderState.NEW || order.state != OrderState.ACCEPTED || order.state != OrderState.READY)) {
        error = true;
        return;
      }
      if (state == OrderState.PICKED_UP && order.state == OrderState.PICKED_UP) return;
      if (state == OrderState.PICKED_UP && order.state != OrderState.READY) {
        error = true;
        return;
      }
      if (state == OrderState.DELIVERED && order.state != OrderState.PICKED_UP) {
        error = true;
        return;
      }
      await tx.update(document, {
        'state': orderStateEncode(state),
        'visualized': false,
        'replied': false,
        timestampField: datetimeToJson(DateTime.now()),
      });
    });
    if (error) throw new Exception(); // TODO: Definire meglio l'eccezione
  }
}
