import 'dart:async';
import 'dart:io';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/OrderTab.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/ReservedShiftTab.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreenDriver.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/CalendarTab.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrderBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';

class HomeScreenDriver extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'HomeScreenDriver';

  @override
  String get route => ROUTE;

  @override
  _HomeScreenDriverState createState() => _HomeScreenDriverState();
}

class _HomeScreenDriverState extends State<HomeScreenDriver> {
  final DriverBloc _driverBloc = DriverBloc.of();
  DateTime date = DateTime.now();

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
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }

  @override
  void dispose() {
    UserBloc.of().logout();
    LoginHelper().signOut();
    _driverBloc.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    firebaseCloudMessagingListeners();
  }

  @override
  Widget build(BuildContext context) {
    dialog = context;
    return DefaultPapyrusController(
      child: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            leading: PapyrusBackIconButton(),
            title: Text("Home"),
            actions: <Widget>[
              IconButton(
                onPressed: () => EasyRouter.push(context, AccountScreenDriver()),
                icon: Icon(Icons.account_circle),
              )
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  text: 'Ordini',
                ),
                Tab(
                  text: 'Turni',
                ),
                Tab(
                  text: 'Calendario',
                ),
              ],
            ),
          ),
          body: TabBarView(
            physics: const NeverScrollableScrollPhysics(),
            children: <Widget>[
              OrderTab(),
              ReservedShiftTab(),
              CalendarTab(),
            ],
          ),
        ),
      ),
    );
  }
}
