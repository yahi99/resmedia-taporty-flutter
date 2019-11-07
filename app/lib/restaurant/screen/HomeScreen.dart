import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/MenuPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/OrdersPage.dart';

class HomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'HomeScreenRestaurant';
  final restBloc;
  final String restId;

  @override
  String get route => ROUTE;

  HomeScreen({@required this.restBloc,@required this.restId});

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
      length: 3,
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
              Tab(
                text: 'Turni',
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
                        TurnScreen(restId: widget.restId),
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
