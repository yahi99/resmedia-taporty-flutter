import 'dart:async';
import 'dart:io';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/IncomeScreen.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/MenuPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/page/OrdersPage.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/EditRestScreen.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/LoginScreen.dart';
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

  StreamController<DateTime> dateStream;

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
    dateStream.close();
  }

  @override
  void initState() {
    super.initState();
    TurnBloc.of().setTurnRestStream();
    dateStream= StreamController<DateTime>.broadcast();
    firebaseCloudMessaging_Listeners();
  }

  @override
  Widget build(BuildContext context) {
    dialog=context;
    final orderBloc = OrdersBloc.of();
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              FlatButton(
                child: Text('Turni Inseriti'),
                onPressed: (){
                  EasyRouter.push(context, TurnsScreen());
                },
              ),
              FlatButton(
                child: Text('Orario Ristorante'),
                onPressed: (){
                  EasyRouter.push(context, TimetableScreen(restBloc: widget.restBloc));
                },
              ),
              FlatButton(
                child: Text('Modifica Dati Ristorante'),
                onPressed: (){
                  EasyRouter.push(context, EditRestScreen());
                },
              ),
              FlatButton(
                child: Text('Log Out'),
                onPressed: ()async{
                  await UserBloc.of().logout();
                  EasyRouter.pushAndRemoveAll(context, LoginScreen());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[
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
              Tab(
                text: 'Saldo',
              )
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
                    if (!orders.hasData || !foods.hasData || !drinks.hasData)
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
                        StreamBuilder<DateTime>(
                          stream: dateStream.stream,
                          builder: (ctx,snap){
                            return IncomeScreen(restId:widget.restId,date: snap.hasData?snap.data:DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day),dateStream: dateStream,);
                          },
                        )
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
