import 'dart:async';

import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class OrderListBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _orderListController.close();
  }

  BehaviorSubject<List<OrderModel>> _orderListController;

  Stream<List<OrderModel>> get outOrders => _orderListController?.stream;

  OrderListBloc.instance() {
    var driverBloc = $Provider.of<DriverBloc>();
    _orderListController = BehaviorController.catchStream<List<OrderModel>>(source: driverBloc.outDriver.switchMap((driver) {
      if (driver?.id == null) return Stream.value(null);
      return _db.getDriverOrdersStream(driver.id);
    }));
  }
}
