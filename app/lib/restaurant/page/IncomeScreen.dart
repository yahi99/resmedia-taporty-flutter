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

class IncomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "IncomeScreen";

  String get route => IncomeScreen.ROUTE;

  final String restId;
  final DateTime date;
  final StreamController dateStream;

  IncomeScreen({
    Key key,
    @required this.dateStream,
    @required this.restId,
    @required this.date,
  }) : super(key: key);

  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<IncomeScreen> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Scaffold(
      body: StreamBuilder<IncomeModel>(
          stream: Database().getRestIncome(widget.date,widget.restId),
          builder: (ctx, snap4) {
            return Container(
              child: Column(
                children: <Widget>[
                  MonthPicker(
                    selectedDate: widget.date,
                    firstDate: DateTime(DateTime.now().year-1,
                        DateTime.now().month, DateTime.now().day - 1),
                    lastDate: DateTime(2020),
                    //displayedMonth: DateTime.now(),
                    //currentDate: DateTime.now(),
                    onChanged: (DateTime date){
                      widget.dateStream.add(date);
                    },
                  ),
                  Text('Saldo Giornaliero '+((snap4.data!=null)?snap4.data.dailyTotal.toString():'0.0')+' euro'),
                ],
              ),
            );
          }),
    );
  }
}