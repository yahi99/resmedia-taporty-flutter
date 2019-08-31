import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/interface/view/CardListView.dart';
import 'package:mobile_app/interface/view/TypeOrderView.dart';
import 'package:mobile_app/interface/widget/SearchBar.dart';
import 'package:mobile_app/logic/bloc/OrdersBloc.dart';
import 'package:mobile_app/logic/bloc/TypesRestaurantsBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/interface/view/type_restaurant.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:mobile_app/model/TypesRestaurantModel.dart';
import 'package:easy_route/easy_route.dart';

class OrdersPage extends StatefulWidget implements WidgetRoute {
  final list;

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
    return SingleChildScrollView(
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
    );
  }
}
