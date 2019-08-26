import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/drivers/interface/page/DetailOrderPage.dart';
import 'package:mobile_app/drivers/interface/sliver/SliverOrderVoid.dart';
import 'package:mobile_app/drivers/interface/view/OrderView.dart';
import 'package:mobile_app/drivers/interface/view/TurnView.dart';
import 'package:mobile_app/drivers/logic/bloc/TurnBloc.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';

class TurnWorkTabDriver extends StatefulWidget {

  final Map<MonthCategory,List<TurnModel>> model;

  TurnWorkTabDriver({
    @required this.model,
  });

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<TurnWorkTabDriver> with AutomaticKeepAliveClientMixin {

  @override
  void initState(){
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final turnBloc=TurnBloc.of();
    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
          return Scaffold(
            body: CustomScrollView(
              slivers:widget.model.keys.map<Widget>((nameGroup) {
              final products = widget.model[nameGroup];
              return SliverPadding(
                padding: const EdgeInsets.symmetric(
                    vertical: 8.0, horizontal: SPACE),
                sliver: SliverOrderVoid(
                  title: Text(translateMonthCategory(nameGroup)),
                  childCount: products.length,
                  builder: (_context, index) {
                    return InkWell(
                      child: TurnView(model: products[index],),
                    );
                  },
                ),
              );
            }).toList(),
            ),
          );
        /*},
    );*/
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
