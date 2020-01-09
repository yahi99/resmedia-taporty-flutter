import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:rxdart/rxdart.dart';

import 'UserBloc.dart';

class OrderBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_driverControl != null) _driverControl.close();
    if (_userControl != null) _userControl.close();
  }

  PublishSubject<List<OrderModel>> _userControl;

  Observable<List<OrderModel>> get outUserOrders => _userControl?.stream;

  PublishSubject<List<OrderModel>> _driverControl;

  Observable<List<OrderModel>> get outDriverOrders => _driverControl?.stream;

  Future setUserStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    _userControl = PublishController.catchStream(source: _db.getUserOrders(restUser.uid));
  }

  Future setDriverStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    _driverControl = PublishController.catchStream(source: _db.getDriverOrders(restUser.uid));
  }

  OrderBloc.instance();

  factory OrderBloc.of() => $Provider.of<OrderBloc>();

  static void close() => $Provider.dispose<OrderBloc>();
}
