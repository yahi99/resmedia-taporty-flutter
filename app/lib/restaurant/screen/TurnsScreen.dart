import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TurnView.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';

class TurnsScreen extends StatefulWidget implements WidgetRoute {

  static const ROUTE = 'TurnsRestaurant';

  @override
  String get route => ROUTE;

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<TurnsScreen>{
  @override
  void initState() {
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    final turnBloc = TurnBloc.of();
    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
    return Scaffold(
      body: StreamBuilder<Map<MonthCategory, List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurnsRest,
        builder: (ctx, snap1)
    {
      return CustomScrollView(
        slivers: snap1.data.keys.map<Widget>((nameGroup) {
          final products = snap1.data[nameGroup];
          return SliverPadding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: SPACE),
            sliver: SliverOrderVoid(
              title: Text(translateMonthCategory(nameGroup)),
              childCount: products.length,
              builder: (_context, index) {
                return InkWell(
                  child: TurnView(
                    model: products[index],
                  ),
                );
              },
            ),
          );
        }).toList(),
      );
    }
    ),
    );
    /*},
    );*/
  }
}
