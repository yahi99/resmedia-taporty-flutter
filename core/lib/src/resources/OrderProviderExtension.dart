import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_core/src/models/OrderModel.dart';
import 'package:resmedia_taporty_core/src/models/OrderProductModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';

extension OrderProviderExtension on DatabaseService {
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

  Future<void> createOrder(String orderId, OrderModel order) async {
    var documentReference = orderCollection.document(orderId);

    await documentReference.setData({...order.toJson(), 'reference': documentReference});
  }

  Future<void> modifyOrder(String newOrderId, String oldOrderId, double cartAmount, double deliveryAmount, List<OrderProductModel> orderProducts, String newPaymentIntentId) async {
    orderProducts = orderProducts.where((o) => o.quantity > 0).toList();

    var orderDocument = orderCollection.document(oldOrderId);
    var error = false;
    await firestore.runTransaction((Transaction tx) async {
      var order = OrderModel.fromFirebase(await tx.get(orderDocument));

      if (order.state == OrderState.NEW && newPaymentIntentId != null) {
        var newOrder = OrderModel(
          productCount: orderProducts.fold(0, (count, product) => count + product.quantity),
          cartAmount: cartAmount,
          deliveryAmount: deliveryAmount,
          driverAmount: order.driverAmount,
          supplierPercentage: order.supplierPercentage,
          products: orderProducts,
          preferredDeliveryTimestamp: order.preferredDeliveryTimestamp,
          creationTimestamp: DateTime.now(),
          customerName: order.customerName,
          customerCoordinates: order.customerCoordinates,
          customerAddress: order.customerAddress,
          customerPhoneNumber: order.customerPhoneNumber,
          customerImageUrl: order.customerImageUrl,
          supplierName: order.supplierName,
          supplierCoordinates: order.supplierCoordinates,
          supplierAddress: order.supplierAddress,
          supplierPhoneNumber: order.supplierPhoneNumber,
          supplierImageUrl: order.supplierImageUrl,
          driverName: order.driverName,
          driverPhoneNumber: order.driverPhoneNumber,
          driverImageUrl: order.driverImageUrl,
          supplierId: order.supplierId,
          driverId: order.driverId,
          customerId: order.customerId,
          state: OrderState.NEW,
          paymentIntentId: newPaymentIntentId,
          shiftStartTime: order.shiftStartTime,
        );

        var newOrderDocRef = orderCollection.document(newOrderId);

        tx.update(orderDocument, {
          'state': orderStateEncode(OrderState.ARCHIVED),
          'archiviationTimestamp': datetimeToTimestamp(DateTime.now()),
          'newOrderId': newOrderDocRef.documentID,
        });

        tx.set(newOrderDocRef, {
          ...newOrder.toJson(),
          'reference': newOrderDocRef,
          'oldOrderId': order.id,
        });
      }
      // Mantieni se nel futuro sarà possibile implementare la modifica con Stripe
      /*else if (order.state == OrderState.ACCEPTED || order.state == OrderState.READY) {
        tx.update(orderDocument, {
          'state': orderStateEncode(OrderState.MODIFIED),
          'prevState': orderStateEncode(order.state),
          'modificationTimestamp': datetimeToTimestamp(DateTime.now()),
          'newProductCount': orderProducts.fold(0, (count, product) => count + product.quantity),
          'newTotalPrice': orderProducts.fold(0, (price, product) => price + product.quantity * product.price),
          'newProducts': orderProducts.map((o) => o.toJson()).toList(),
        });
      } */
      else {
        error = true;
        return;
      }
    });

    if (error) throw new InvalidOrderStateException("Invalid order state!");
  }

  Future setPickedUp(String orderId) async {
    var document = orderCollection.document(orderId);
    bool error = false;
    await Firestore.instance.runTransaction((Transaction tx) async {
      var order = OrderModel.fromFirebase(await tx.get(document));
      var update = Map<String, dynamic>();
      if (order.state == OrderState.PICKED_UP) {
      } else if (order.state != OrderState.READY) {
        error = true;
      } else if (order.supplierPickedUp == true) {
        update = {
          'state': orderStateEncode(OrderState.PICKED_UP),
          'driverPickedUp': true,
        };
      } else {
        update = {
          'driverPickedUp': true,
          'pickupTimestamp': datetimeToTimestamp(DateTime.now()),
        };
      }
      await tx.update(document, update);
    });
    if (error) throw new InvalidOrderStateException("Invalid order state!");
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
      if (state == OrderState.CANCELLED && order.state != OrderState.NEW) {
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
        timestampField: datetimeToTimestamp(DateTime.now()),
      });
    });
    if (error) throw new InvalidOrderStateException("Invalid order state!");
  }
}
