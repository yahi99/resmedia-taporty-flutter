import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    if (_orderListController != null) _orderListController.close();
    if (_orderController != null) _orderController.close();
  }

  BehaviorSubject<List<OrderModel>> _orderListController;

  Stream<List<OrderModel>> get outDriverOrders => _orderListController?.stream;

  BehaviorSubject<OrderModel> _orderController;

  Stream<OrderModel> get outOrder => _orderController?.stream;

  setOrderStream(String orderId) {
    _orderController = BehaviorController.catchStream(source: _db.getOrderStream(orderId));
  }

  Future setDriverStream(String driverId) async {
    _orderListController = BehaviorController.catchStream(source: _db.getDriverOrdersStream(driverId));
  }

  OrderBloc.instance();
}
