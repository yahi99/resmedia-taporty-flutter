import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/DetailOrderPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/tab/OrdersTab.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/OrderView.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

/*class OrdersPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrdersPageDriver";
  String get route => OrdersPageDriver.ROUTE;

  @override
  _OrdersPageDriverState createState() => _OrdersPageDriverState();
}

class _OrdersPageDriverState extends State<OrdersPageDriver> {
  bool isDeactivate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    initMap(context);
  }

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  initMap(BuildContext context) async {
    if (isDeactivate) return;
    await PrimaryGoogleMapsController.of(context).future
    ..setMarkers(currentOrder.map((order) {
      return Marker(
        markerId: MarkerId(order.id),
        position: order.supplier.position,
        infoWindow: InfoWindow(
          title: "F. ${order.supplier.title}", snippet: "C. ${order.receiver.title}",
          onTap: () => EasyRouter.push(context, DetailOrderPageDriver(model: order,)),
        ),
      );
    }).toSet())
    ..animateToCenter(currentOrder.map((order) => order.receiver.position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const RubberConcierge(),
      ),
      body: CustomScrollView(
        controller: RubberScrollController.of(context),
        physics: NeverScrollableScrollPhysics(),
        slivers: orders.keys.map<Widget>((key) {
          final values = orders[key];
          return SliverPadding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: SPACE),
            sliver: SliverOrderVoid(
              title: Text("$key"),
              childCount: values.length,
              builder: (_context, index) {
                return InkWell(
                  onTap: () => EasyRouter.push(_context, DetailOrderPageDriver(model: values[index],)),
                  child: OrderView(model: values[index],),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
  }
}*/

class OrdersPageDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrdersPageDriver";

  String get route => OrdersPageDriver.ROUTE;

  final Map<StateCategory, List<DriverOrderModel>> model;

  OrdersPageDriver({
    @required this.model,
  });

  @override
  _OrdersPageDriverState createState() => _OrdersPageDriverState();
}

class _OrdersPageDriverState extends State<OrdersPageDriver> {
  bool isDeactivate = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    //initMap(context);
  }

  void deactivate() {
    super.deactivate();
    isDeactivate = !isDeactivate;
  }

  /*initMap(BuildContext context) async {
    if (isDeactivate) return;
    await PrimaryGoogleMapsController.of(context).future
      ..setMarkers(currentOrder.map((order) {
        return Marker(
          markerId: MarkerId(order.id),
          position: order.supplier.toLatLng(),
          infoWindow: InfoWindow(
            title: "F. ${order.supplier.title}", snippet: "C. ${order.receiver.title}",
            onTap: () => EasyRouter.push(context, DetailOrderPageDriver(model: order,)),
          ),
        );
      }).toSet())
      ..animateToCenter(currentOrder.map((order) => order.receiver.toLatLng()));
  }*/

  /*Map<String,List<RestaurantOrderModel>> getMap(List<RestaurantOrderModel> orders){
    Map<String,List<RestaurantOrderModel>> map= new Map<String,List<RestaurantOrderModel>>();
    for(int i=0;i<orders.length;i++){
      final key=orders.elementAt(i).state;
      if(map.containsKey(key)){
        final value =map.remove(key);
        value.add(orders.elementAt(i));
        map.putIfAbsent(key, ifAbsent).update(key, value);
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    /*final orderBloc=OrdersBloc.of();
    //orderBloc.setDriverStream();
    print('lol');
    return CacheStreamBuilder<Map<StateCategory,List<DriverOrderModel>>>(
        stream: orderBloc.outCategorizedOrders,
        builder: (context, snap)
    {
      if (!snap.hasData) return Center(child: CircularProgressIndicator(),);
      print(snap.hasData);*/
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const RubberConcierge(),
      ),
      body: CustomScrollView(
        controller: RubberScrollController.of(context),
        physics: NeverScrollableScrollPhysics(),
        slivers: widget.model.keys.map<Widget>((nameGroup) {
          final products = widget.model[nameGroup];
          return SliverPadding(
            padding:
                const EdgeInsets.symmetric(vertical: 8.0, horizontal: SPACE),
            sliver: SliverOrderVoid(
              title: Text(translateOrderCategory(nameGroup)),
              childCount: products.length,
              builder: (_context, index) {
                return InkWell(
                  onTap: () => EasyRouter.push(
                      _context,
                      DetailOrderPageDriver(
                        model: products[index],
                      )),
                  child: OrderView(
                    model: products[index],
                  ),
                );
              },
            ),
          );
        }).toList(),
      ),
    );
    /*}
    );*/
  }
}
