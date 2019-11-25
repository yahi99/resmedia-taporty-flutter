import 'dart:async';
import 'dart:io';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/DriverRequests.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ManageOrders.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ProductRequestsScreen.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/ResetPasswordAdmin.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/RestaurantRequestScreen.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantsBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';

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
    //_driverBloc.close();
    //_calendarBloc.close();
    super.dispose();
  }

  /*void setUser() async {
    final userB = UserBloc.of();
    user = (await userB.outFirebaseUser.first).uid;
  }*/

  @override
  void initState() {
    //stream=_calendarBloc.outCalendar;
    //setUser();
    firebaseCloudMessaging_Listeners();
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    dialog=context;
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FlatButton(
            child: Text('  Richieste Ristoratori  '),
            onPressed: (){
              EasyRouter.push(context, RestaurantRequestsScreen());
            },
          ),
          FlatButton(
            child: Text('  Richieste Fattorini  '),
            onPressed: (){
              EasyRouter.push(context, DriverRequestsScreen());
            },
          ),
          FlatButton(
            child: Text('  Richieste Prodotti  '),
            onPressed: (){
              EasyRouter.push(context, ProductRequestsScreen());
            },
          ),
          FlatButton(
            child: Text('  Crea amministratore  '),
            onPressed: (){
              EasyRouter.push(context, CreateAdminScreen());
            },
          ),
          FlatButton(
            child: Text('  Reset Password Admin  '),
            onPressed: ()async{
              EasyRouter.push(context, ResetPasswordAdmin(userId: (await UserBloc.of().outFirebaseUser.first).uid,));
            },
          ),
          FlatButton(
            child: Text('Gestisci utenti'),
            onPressed: (){
              EasyRouter.push(context, ManageUsers());
            },
          ),
          FlatButton(
            child: Text('Gestisci ristoranti'),
            onPressed: (){
              EasyRouter.push(context, ManageRestaurants());
            },
          ),
          FlatButton(
            child: Text('Gestisci ordini'),
            onPressed: (){
              EasyRouter.push(context, ManageOrders());
            },
          ),
          FlatButton(
            child: Text('Saldo Totale'),
            onPressed: (){
              EasyRouter.push(context, TotalIncomeScreen());
            },
          )
        ],
      ),
    );
  }
}
