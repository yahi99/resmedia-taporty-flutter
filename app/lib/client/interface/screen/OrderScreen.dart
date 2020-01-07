import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/TypeUserOrderView.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';

class OrderScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "OrderScreen";

  @override
  String get route => OrderScreen.ROUTE;

  @override
  OrderScreenState createState() => OrderScreenState();
}

class OrderScreenState extends State<OrderScreen> {
  static const double SPACE_CELL = 8.0;

  @override
  void initState() {
    super.initState();
    //OrderBloc.of().setRestaurantStream();
  }

  void dispose() {
    OrderBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista Ordini'),
        backgroundColor: ColorTheme.RED,
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
    final orderBloc = OrderBloc.of();
    return CacheStreamBuilder<List<OrderModel>>(
      stream: orderBloc.outUserOrders,
      builder: (context, orderSnapshots) {
        if (!orderSnapshots.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        return (orderSnapshots.data.length > 0)
            ? SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: orderSnapshots.data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: TypeOrderView(
                          order: orderSnapshots.data[index],
                        ),
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
