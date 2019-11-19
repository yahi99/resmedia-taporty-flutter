import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/MenuPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/OrdersPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/EditRestScreen.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/TurnsScreen.dart';

import 'TimetableScreen.dart';

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

  BuildContext dialog;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void showNotification(BuildContext context, Map<String, dynamic> message) async {
    print('Build dialog');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: ListTile(
          title: Text(message['notification']['title']),
          subtitle: Text(message['notification']['body']),
        ),
        actions: <Widget>[
          FlatButton(
            child: Text('Ok'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  void firebaseCloudMessaging_Listeners() {
    if (Platform.isIOS) iOS_Permission();
    print('ok');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if(dialog!=null) showNotification(dialog,message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOS_Permission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    dialog=context;
    final orderBloc = OrdersBloc.of();
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              FlatButton(
                child: Text('Turni Inseriti'),
                onPressed: (){
                  TurnBloc.of().setTurnRestStream();
                  EasyRouter.push(context, TurnsScreen());
                },
              ),
              FlatButton(
                child: Text('Orario Ristorante'),
                onPressed: (){
                  EasyRouter.push(context, TimetableScreen());
                },
              ),
              FlatButton(
                child: Text('Modifica Dati Ristorante'),
                onPressed: (){
                  EasyRouter.push(context, EditRestScreen());
                },
              ),
            ],
          ),
        ),
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
