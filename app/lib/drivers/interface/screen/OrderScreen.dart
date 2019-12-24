import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TypeUserOrderView.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/mainRestaurant.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class OrderListScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderListScreen";

  @override
  String get route => OrderListScreen.ROUTE;

  @override
  OrderListScreenState createState() => OrderListScreenState();
}

class OrderListScreenState extends State<OrderListScreen> {
  static const double SPACE_CELL = 8.0;

  @override
  void initState() {
    super.initState();
    //OrdersBloc.of().setRestaurantStream();
  }

  void dispose() {
    OrdersBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Ordini'),
        backgroundColor: red,
        centerTitle: true,
        actions: <Widget>[],
      ),
      body: TypesRestaurantView(),
    );
  }
}

class TypesRestaurantView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /*CacheStreamBuilder<List<RestaurantModel>>(
    stream: _restaurantBloc.outRestaurants,
    builder: (context, snap) {
    if (!snap.hasData) return Center(child: CircularProgressIndicator(),);
    return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: snap.data.map<Widget>((_model) {
    return Expanded(child: InkWell(
    onTap: () => EasyRouter.push(context, RestaurantScreen(model: _model),),
    child: RestaurantCellView(model: _model,)),);
    }).toList()..insert(1, SizedBox(width: SPACE_CELL,),),
    );*/
    final orderBloc = OrdersBloc.of();
    // orderBloc.setRestaurantStream();
    return CacheStreamBuilder<List<UserOrderModel>>(
      stream: orderBloc.outUserOrders,
      builder: (context, snap) {
        if (!snap.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        print(snap.hasData);
        return (snap.data.length > 0)
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: snap.data.length,
                    itemBuilder: (context, index) {
                      return TypeOrderView(
                        model: snap.data[index],
                      );
                    },
                  ),
                ),
              )
            : Padding(
                child: Text(
                  'Non ci sono ordini.',
                  style: Theme.of(context).textTheme.subtitle,
                ),
                padding: EdgeInsets.all(8.0),
              );
      },
    );
  }
}
