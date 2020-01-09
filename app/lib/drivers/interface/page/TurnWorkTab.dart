import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/SliverOrderVoid.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/view/TurnView.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';

class TurnWorkTabDriver extends StatefulWidget {
  final Map<MonthCategory, List<TurnModel>> model;

  TurnWorkTabDriver({
    @required this.model,
  });

  @override
  _TurnWorkTabDriverState createState() => _TurnWorkTabDriverState();
}

class _TurnWorkTabDriverState extends State<TurnWorkTabDriver> with AutomaticKeepAliveClientMixin {
  @override
  void initState() {
    super.initState();
    //final bloc=TurnBloc.of();
    //bloc.setTurnStream();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    /*return StreamBuilder<Map<MonthCategory,List<TurnModel>>>(
        stream: turnBloc.outCategorizedTurns ,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);*/
    return Scaffold(
      body: (widget.model.length > 0)
          ? CustomScrollView(
              slivers: widget.model.keys.map<Widget>((nameGroup) {
                final products = widget.model[nameGroup];
                return SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
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
            )
          : Padding(
              child: Text('Non ci sono turni.'),
              padding: EdgeInsets.all(8.0),
            ),
    );
    /*},
    );*/
  }

  @override
  bool get wantKeepAlive => true;
}
