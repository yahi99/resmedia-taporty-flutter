import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/interface/view/CardListView.dart';
import 'package:resmedia_taporty_flutter/interface/view/TypeOrderView.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

class OrdersPage extends StatefulWidget implements WidgetRoute {
  final List<RestaurantOrderModel> list;

  static const ROUTE = "OrdersPage";

  @override
  String get route => OrdersPage.ROUTE;

  OrdersPage({@required this.list});

  @override
  OrdersPageState createState() => OrdersPageState();
}

class OrdersPageState extends State<OrdersPage> {
  static const double SPACE_CELL = 8.0;

  @override
  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.list.length>0)? SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: CardListView(
          children: widget.list.map<Widget>((_model) {
            //return Center(child: CircularProgressIndicator(),);
            return TypeOrderView(
              model: _model,
            );
          }).toList(),
        ),
      ),
    ):Padding(child: Text('Non ci sono ordini'),padding: EdgeInsets.all(8.0),);
  }
}
