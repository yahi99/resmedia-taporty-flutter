import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:rxdart/rxdart.dart';

import 'UserBloc.dart';

class OrdersBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_restaurantsControl != null) _restaurantsControl.close();
    if (_restaurantsControlMod != null) _restaurantsControlMod.close();
    if (_driverControl != null) _driverControl.close();
    if (_userControl != null) _userControl.close();
  }

  PublishSubject<List<RestaurantOrderModel>> _restaurantsControl;

  Stream<List<RestaurantOrderModel>> get outOrders =>
      _restaurantsControl.stream;

  PublishSubject<List<RestaurantOrderModel>> _restaurantsControlMod;

  Stream<List<RestaurantOrderModel>> get outOrdersCtrl =>
      _restaurantsControlMod.stream;

  PublishSubject<List<UserOrderModel>> _userControl;

  Stream<List<UserOrderModel>> get outUserOrders => _userControl.stream;

  PublishSubject<List<DriverOrderModel>> _driverControl;

  Stream<List<DriverOrderModel>> get outDriverOrders => _driverControl.stream;

  Stream<Map<StateCategory, List<DriverOrderModel>>> get outCategorizedOrders =>
      outDriverOrders.map((models) {
        return categorized(
            StateCategory.values, models, (model) => model.state);
      });
  Stream<Map<StateCategory, List<RestaurantOrderModel>>> get outCategorizedOrdersCtrl =>
      outOrdersCtrl.map((models) {
        return categorized(
            StateCategory.values, models, (model) => model.state);
      });

  void see() {}

  void setUserStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    //final restId= await _db.getRestaurantId(restUser.uid);
    //final str=await _db.getUserOrders(restUser.uid).first;
    //print('lol');
    _userControl =
        PublishController.catchStream(source: _db.getUserOrders(restUser.uid));
    _userControl.listen(print);
  }

  void setCtrlStream(){
    _restaurantsControlMod=PublishController.catchStream(source: _db.getCtrlOrders());
    _userControl.listen(print);
  }

  void setRestaurantStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    final restId = await _db.getRestaurantId(restUser.uid);
    //final str=await _db.getRestaurantOrders(restUser.uid, restId).first;
    //print('lol');
    _restaurantsControl =
        PublishController.catchStream(source: _db.getRestaurantOrders(restId));
    _restaurantsControl.listen(print);
  }

  void setDriverStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    //final str=await _db.getDriverOrders(restUser.uid).first;
    print('lol');
    _driverControl = PublishController.catchStream(
        source: _db.getDriverOrders(restUser.uid));
    _driverControl.listen(print);
  }

  OrdersBloc.instance() {
    //_restaurantsControl = PublishController.catchStream(source: _db.getRestaurantOrders(uid, restaurantId));
  }

  factory OrdersBloc.of() => $Provider.of<OrdersBloc>();

  static void close() => $Provider.dispose<OrdersBloc>();
}
