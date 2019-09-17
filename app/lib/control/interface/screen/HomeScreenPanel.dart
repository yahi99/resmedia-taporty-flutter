import 'dart:async';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/TurnScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/DriverBloc.dart';

class HomeScreenPanel extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'HomeScreenPanel';

  @override
  String get route => ROUTE;

  @override
  _HomeScreenPanelState createState() => _HomeScreenPanelState();
}

class _HomeScreenPanelState extends State<HomeScreenPanel> {

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
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        actions: <Widget>[
        ],
      ),
      body: Column(
        children: <Widget>[
          FlatButton(
            child: Text('  Aggiungi Turni Fattorini  '),
            onPressed: (){
              EasyRouter.push(context, TurnScreen());
            },
          ),
          FlatButton(
            child: Text('  Richieste Prodotti  '),
            onPressed: (){
              //EasyRouter.push(context, ProductRequestsScreen());
            },
          ),
        ],
      ),
    );
  }
}
