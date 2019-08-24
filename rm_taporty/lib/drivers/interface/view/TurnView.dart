import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:mobile_app/drivers/interface/widget/Order.dart';
import 'package:mobile_app/drivers/model/OrderModel.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';


class TurnView extends StatelessWidget {
  final TurnModel model;

  TurnView({Key key, @required this.model}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Slidable(
        actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.25,
    secondaryActions: <Widget>[
    IconSlideAction(
    icon: Icons.close,
    color: theme.accentColor,
    onTap: (){

    },
    )
    ],
    child:Order(
      children: <Widget>[
        Expanded(
          child: TurnVoid(model: model,),
        ),
      ],
    ),
    );
  }
}


class TurnVoid extends StatelessWidget {
  final TurnModel model;

  TurnVoid({Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final date=DateTime.tryParse(model.day);
    return Row(
      //mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
    child:new Column(
        children: <Widget>[
            Text(model.startTime,style: tt.body1),
            Text(model.endTime,style: tt.body1),
          ],
        ),
          padding: EdgeInsets.only(left: 16.0),
    ),
        Padding(
    padding: EdgeInsets.only(left:16.0,right: 16.0),
    child: Container(
      height: 30.0,
      width: 2.0,
      color: Colors.grey,
    ),
    ),

        Text(weekDay(date.weekday)+' '+date.day.toString()),
      ],
    );
  }
  String weekDay(int value){
    if(value==1) return "Lunedì";
    else if(value==2) return "Martedì";
    else if(value==3) return "Mercoledì";
    else if(value==4) return "Giovedì";
    else if(value==5) return "Venerdì";
    else if(value==6) return "Sabato";
    return "Domenica";
  }
}