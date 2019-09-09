import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/logic/bloc/OrdersBloc.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:mobile_app/model/ProductModel.dart';
import 'package:mobile_app/restaurant/page/MenuPage.dart';
import 'package:mobile_app/restaurant/page/OrdersPage.dart';

class HomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'HomeScreenRestaurant';
  final restBloc;

  @override
  String get route => ROUTE;

  HomeScreen({@required this.restBloc});

  @override
  _HomeScreenRestaurantState createState() => _HomeScreenRestaurantState();
}

class _HomeScreenRestaurantState extends State<HomeScreen> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final orderBloc = OrdersBloc.of();
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
            IconButton(
              onPressed: () {},
              icon: Icon(Icons.account_circle),
            )
          ],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ordini',
              ),
              Tab(
                text: 'Listino',
              ),
            ],
          ),
        ),
        body: CacheStreamBuilder<List<RestaurantOrderModel>>(
          stream: orderBloc.outOrders,
          builder: (context, orders) {
            return StreamBuilder<List<DrinkModel>>(
              stream: widget.restBloc.outDrinks,
              builder: (context, drinks) {
                return StreamBuilder<List<FoodModel>>(
                  stream: widget.restBloc.outFoods,
                  builder: (context, foods) {
                    if (!orders.hasData || !foods.hasData || !orders.hasData)
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    return TabBarView(
                      physics: const NeverScrollableScrollPhysics(),
                      children: <Widget>[
                        OrdersPage(list: orders.data),
                        MenuPage(
                          foods: foods.data,
                          drinks: drinks.data,
                        ),
                      ],
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
