import 'dart:async';

import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';

class OrderBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    if (_orderListController != null) _orderListController.close();
    if (_orderListController != null) _orderController.close();
  }

  StreamController<List<OrderModel>> _orderListController;

  Stream<List<OrderModel>> get outOrders => _orderListController?.stream;

  StreamController<OrderModel> _orderController;

  Stream<OrderModel> get outOrder => _orderController?.stream;

  setOrderStream(String orderId) {
    _orderController.close();
    _orderController = StreamController.broadcast();
    _orderController.addStream(_db.getOrderStream(orderId));
  }

  Future setUserStream(String userId) async {
    _orderListController.close();
    _orderListController = StreamController.broadcast();
    _orderListController.addStream(_db.getUserOrdersStream(userId));
  }

  OrderBloc.instance();
}
