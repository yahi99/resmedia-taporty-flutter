import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TurnView.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

class TurnsScreen extends StatefulWidget implements WidgetRoute {

  static const ROUTE = 'TurnsRestaurant';

  final String restId;

  TurnsScreen({this.restId});

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


    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
    //final turnBloc = TurnBloc.of();
    return Scaffold(
      appBar: AppBar(
        title: Text('Turni Inseriti'),
      ),
      body: StreamBuilder<List<TurnModel>>(
    stream: Database().getTurnsRest(widget.restId),
    builder: (ctx, snap1) {
    if (snap1.hasData && snap1.data.length > 0) {
      final temp = categorized(
          MonthCategory.values, snap1.data, (model) => model.month);
      return CustomScrollView(
        slivers: temp.keys.map<Widget>((nameGroup) {
          final products = temp[nameGroup];
          return SliverPadding(
            padding:
            const EdgeInsets.symmetric(vertical: 8.0, horizontal: SPACE),
            sliver: SliverOrderVoid(
              title: Text(translateMonthCategory(nameGroup)),
              childCount: products.length,
              builder: (_context, index) {
                return InkWell(
                  child: TurnViewRest(
                    model: products[index],
                  ),
                );
              },
            ),
          );
        }).toList(),
      );
    }
      else return Padding(child: Text('Non ci sono turni inseriti'),padding: EdgeInsets.all(8.0),);
    }
    ),
    );
    /*},
    );*/
  }
}
