import 'dart:async';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/IncomeModel.dart';

class TotalIncomeScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "IncomeScreen";

  String get route => TotalIncomeScreen.ROUTE;

  final DateTime date;
  final StreamController dateStream;

  TotalIncomeScreen({
    Key key,
    @required this.dateStream,
    @required this.date,
  }) : super(key: key);
  @override
  _DetailOrderRestaurantPageState createState() =>
      _DetailOrderRestaurantPageState();
}

class _DetailOrderRestaurantPageState extends State<TotalIncomeScreen> {


  @override
  void initState(){
    super.initState();
  }

  @override
  void dispose(){
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<IncomeModel>(
          stream: Database().getTotalIncome(widget.date),
          builder: (ctx, snap4) {
            return Container(
              child: ListView(
                shrinkWrap: true,
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
