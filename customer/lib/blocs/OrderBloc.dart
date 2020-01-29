import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _orderIdController.close();
    _orderController.close();
  }

  BehaviorSubject<String> _orderIdController;

  BehaviorSubject<OrderModel> _orderController;

  Stream<OrderModel> get outOrder => _orderController?.stream;

  setOrderStream(String orderId) {
    _orderIdController.value = orderId;
  }

  void clear() {
    _orderIdController.value = null;
  }

  OrderBloc.instance() {
    _orderIdController = BehaviorSubject.seeded(null);
    _orderController = BehaviorController.catchStream<OrderModel>(source: _orderIdController.switchMap((orderId) {
      if (orderId == null) return Stream.value(null);
      return _db.getOrderStream(orderId);
    }));
  }
}
