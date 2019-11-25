import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/IncomeModel.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';

class TotalIncomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "IncomeScreen";

  String get route => TotalIncomeScreen.ROUTE;

  TotalIncomeScreen({
    Key key,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<TotalIncomeScreen> {

  StreamController dateStream;

  @override
  void initState(){
    super.initState();
    dateStream=StreamController<DateTime>.broadcast();
  }

  @override
  void dispose(){
    super.dispose();
    dateStream.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Scaffold(
      body: StreamBuilder<DateTime>(
          stream: dateStream.stream,
          builder: (ctx, snap4) {
            if (!snap4.hasData)
              return Center(child: CircularProgressIndicator());
            return Container(
              child: Column(
                children: <Widget>[
                  MonthPicker(
                    selectedDate: snap4.data,
                    firstDate: DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day - 1),
                    lastDate: DateTime(2020),
                    //displayedMonth: DateTime.now(),
                    //currentDate: DateTime.now(),
                    onChanged: (DateTime date){
                      dateStream.add(date);
                    },
                  ),
                  StreamBuilder(
                    stream: snap4.hasData?Database().getTotalIncome(snap4.data):Database().getTotalIncome(DateTime(DateTime.now().year,
                        DateTime.now().month, DateTime.now().day)),
                    builder: (ctx,snap){
                      if(snap.hasData) return Center(child: CircularProgressIndicator(),);
                      return Text('Saldo Giornaliero '+((snap.data.dailyTotal!=null)?snap.data.dailyTotal.toString():'0.0'));
                    },
                  )
                ],
              ),
            );
          }),
    );
  }
}
