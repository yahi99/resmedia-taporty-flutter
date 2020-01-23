import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class OrderBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_driverControl != null) _driverControl.close();
    if (_userControl != null) _userControl.close();
    if (_userControl != null) _orderFetcher.close();
  }

  PublishSubject<List<OrderModel>> _userControl;

  Stream<List<OrderModel>> get outUserOrders => _userControl?.stream;

  PublishSubject<List<OrderModel>> _driverControl;

  Stream<List<OrderModel>> get outDriverOrders => _driverControl?.stream;

  PublishSubject<OrderModel> _orderFetcher;

  Stream<OrderModel> get outOrder => _orderFetcher?.stream;

  setOrderStream(String orderId) {
    _orderFetcher = PublishController.catchStream(source: _db.getOrderStream(orderId));
  }

  Future setUserStream(String userId) async {
    _userControl = PublishController.catchStream(source: _db.getUserOrdersStream(userId));
  }

  Future setDriverStream(String driverId) async {
    _driverControl = PublishController.catchStream(source: _db.getDriverOrdersStream(driverId));
  }

  OrderBloc.instance();
}
