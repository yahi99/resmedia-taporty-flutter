import 'dart:async';

import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
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
    var userBloc = $Provider.of<UserBloc>();
    _orderListController = BehaviorController.catchStream<List<OrderModel>>(source: userBloc.outUser.switchMap((user) {
      if (user?.id == null) return Stream.value(null);
      return _db.getUserOrdersStream(user.id);
    }));
  }
}
