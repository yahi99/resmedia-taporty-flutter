import 'dart:async';
import 'dart:io';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/helper/LoginHelper.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/page/OrdersPage.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/AccountScreenDriver.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/tab/CalendarTab.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/tab/TurnWorkTab.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

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
  final StreamController<DateTime> dateStream = StreamController<DateTime>();
  final CalendarBloc _calendarBloc = CalendarBloc.of();
  var user;

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
    _calendarBloc.close();
    super.dispose();
  }

  void setUser() async {
    final userB = UserBloc.of();
    user = (await userB.outFirebaseUser.first).uid;
  }

  @override
  void initState() {
    //stream=_calendarBloc.outCalendar;
    setUser();
    super.initState();
    firebaseCloudMessagingListeners();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    dialog = context;
    final turnBloc = TurnBloc.of();
    final orderBloc = OrdersBloc.of();
    //final timeBloc = TimeBloc.of();
    final calStream = StreamController<List<CalendarModel>>();
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
          body: StreamBuilder<List<TurnModel>>(
            stream: Database().getTurns(user),
            builder: (ctx, snap1) {
              return StreamBuilder<List<OrderModel>>(
                stream: orderBloc.outDriverOrders,
                builder: (context, driverOrderListSnapshot) {
                  return StreamBuilder<DateTime>(
                    stream: dateStream.stream,
                    builder: (context, snap3) {
                      if (!snap1.hasData || !driverOrderListSnapshot.hasData)
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      return TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        children: <Widget>[
                          OrdersPageDriver(
                            model: categorized(OrderState.values, driverOrderListSnapshot.data, (model) => model.state),
                          ),
                          TurnWorkTabDriver(
                            model: categorized(MonthCategory.values, snap1.data, (model) => model.month),
                          ),
                          CalendarTabDriver(
                            //model: (!snap4.hasData)?snap4.data:List<CalendarModel>(),
                            //callback: callback,
                            date: (snap3.hasData) ? snap3.data : DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day),
                            user: user,
                            dateStream: dateStream,
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
      ),
    );
  }
}

Map<C, List<M>> categorized<C, M>(
  List<C> allCategories,
  List<M> models,
  C getterCategory(M model),
) {
  final categories = allCategories.where((category) {
    return models.map(getterCategory).any((modelCategory) => category == modelCategory);
  });
  return Map.fromIterable(
    categories,
    key: (category) {
      return category;
    },
    value: (category) {
      return models.where((model) => getterCategory(model) == category).toList();
    },
  );
}
