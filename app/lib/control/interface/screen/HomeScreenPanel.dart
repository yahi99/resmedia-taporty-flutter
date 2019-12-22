import 'dart:async';
import 'dart:io';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/DriverRequests.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ManageOrders.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ProductRequestsScreen.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ResetPasswordAdmin.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/RestaurantRequestScreen.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

import 'CreateAdminScreen.dart';
import 'ManageRestaurants.dart';
import 'ManageUsers.dart';
import 'TotalIncomeScreen.dart';

class HomeScreenPanel extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'HomeScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _HomeScreenPanelState createState() => _HomeScreenPanelState();
}

class _HomeScreenPanelState extends State<HomeScreenPanel> {
  StreamController<DateTime> dateStream;

  BuildContext dialog;

  OrdersBloc orderBloc;

  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void showNotification(
      BuildContext context, Map<String, dynamic> message) async {
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

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) iOSPermission();
    print('ok');
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print('on message $message');
        if (dialog != null) showNotification(dialog, message);
      },
      onResume: (Map<String, dynamic> message) async {
        print('on resume $message');
      },
      onLaunch: (Map<String, dynamic> message) async {
        print('on launch $message');
      },
    );
  }

  void iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    //_driverBloc.close();
    //_calendarBloc.close();
    UserBloc.of().logout();
    LoginHelper().signOut();
    super.dispose();
    dateStream.close();
  }

  /*void setUser() async {
    final userB = UserBloc.of();
    user = (await userB.outFirebaseUser.first).uid;
  }*/

  @override
  void initState() {
    //stream=_calendarBloc.outCalendar;
    //setUser();
    dateStream = StreamController<DateTime>.broadcast();
    orderBloc = OrdersBloc.of();
    firebaseCloudMessagingListeners();
    firebaseCloudMessagingListeners();
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    dialog = context;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        drawer: Drawer(
          child: ListView(
            children: <Widget>[
              FlatButton(
                child: Text('  Richieste Ristoratori  '),
                onPressed: () {
                  EasyRouter.push(context, RestaurantRequestsScreen());
                },
              ),
              FlatButton(
                child: Text('  Richieste Fattorini  '),
                onPressed: () {
                  EasyRouter.push(context, DriverRequestsScreen());
                },
              ),
              FlatButton(
                child: Text('  Richieste Prodotti  '),
                onPressed: () {
                  EasyRouter.push(context, ProductRequestsScreen());
                },
              ),
              FlatButton(
                child: Text('  Crea amministratore  '),
                onPressed: () {
                  EasyRouter.push(context, CreateAdminScreen());
                },
              ),
              FlatButton(
                child: Text('  Reset Password Admin  '),
                onPressed: () async {
                  EasyRouter.push(
                      context,
                      ResetPasswordAdmin(
                        userId: (await UserBloc.of().outFirebaseUser.first).uid,
                      ));
                },
              ),
              FlatButton(
                child: Text('Gestisci utenti'),
                onPressed: () {
                  EasyRouter.push(context, ManageUsers());
                },
              ),
              FlatButton(
                child: Text('Gestisci ristoranti'),
                onPressed: () {
                  EasyRouter.push(context, ManageRestaurants());
                },
              ),
              FlatButton(
                child: Text('Log Out'),
                onPressed: () async {
                  UserBloc.of().logout();
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          title: Text("Home"),
          actions: <Widget>[],
          bottom: TabBar(
            tabs: [
              Tab(
                text: 'Ordini',
              ),
              Tab(
                text: 'Saldo',
              )
            ],
          ),
        ),
        body: StreamBuilder<List<RestaurantOrderModel>>(
          stream: orderBloc.outOrdersCtrl,
          builder: (context, orders) {
            if (!orders.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            return TabBarView(
              physics: const NeverScrollableScrollPhysics(),
              children: <Widget>[
                ManageOrders(list: orders.data),
                StreamBuilder<DateTime>(
                  stream: dateStream.stream,
                  builder: (ctx, snap) {
                    return TotalIncomeScreen(
                      date: snap.hasData
                          ? snap.data
                          : DateTime(DateTime.now().year, DateTime.now().month,
                              DateTime.now().day),
                      dateStream: dateStream,
                    );
                  },
                )
              ],
            );
          },
        ),
      ),
    );
  }
}
