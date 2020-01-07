import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/Order.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:toast/toast.dart';

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
          onTap: () async {
            //TODO:DELETE TURN
            final temp = model.endTime.split(':');
            final date = DateTime.parse(model.day);
            double difference = DateTime(date.year, date.month, date.day, int.parse(temp.elementAt(0)), int.parse(temp.elementAt(1))).difference(DateTime.now()).inSeconds / 60 / 60;
            print(difference);
            if (difference > 0 && difference < 48.0) Toast.show('Non puoi modificare turni nelle prossime 48 ore!', context, duration: 5);
            if (difference > 48) Database().removeShiftDriver(model.startTime, model.day, (await UserBloc.of().outUser.first).model.id);
          },
        )
      ],
      child: Order(
        children: <Widget>[
          Expanded(
            child: TurnVoid(
              model: model,
              //date:model.day
            ),
          ),
        ],
      ),
    );
  }
}

class TurnViewRest extends StatelessWidget {
  final TurnModel model;

  TurnViewRest({Key key, @required this.model}) : super(key: key);

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
          onTap: () async {
            final temp = model.endTime.split(':');
            final date = DateTime.parse(model.day);
            double difference = DateTime(date.year, date.month, date.day, int.parse(temp.elementAt(0)), int.parse(temp.elementAt(1))).difference(DateTime.now()).inSeconds / 60 / 60;
            if (difference > 48) Database().removeShiftRest(model.startTime, model.day, (await UserBloc.of().outUser.first).model.restaurantId);
            if (difference > 0 && difference < 48.0) Toast.show('Non puoi modificare turni nelle prossime 48 ore!', context, duration: 5);
          },
        )
      ],
      child: Order(
        children: <Widget>[
          Expanded(
            child: TurnVoid(
              model: model,
              //date:model.day
            ),
          ),
        ],
      ),
    );
  }
}

class TurnVoid extends StatelessWidget {
  final TurnModel model;

  TurnVoid({
    Key key,
    @required this.model,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    final date = DateTime.tryParse(model.day);
    return Row(
      //mainAxisSize: MainAxisSize.min,
      //crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          child: Column(
            children: <Widget>[
              Text(model.startTime, style: tt.body1),
              Text(model.endTime, style: tt.body1),
            ],
          ),
          padding: EdgeInsets.only(left: 16.0),
        ),
        Padding(
          padding: EdgeInsets.only(left: 16.0, right: 16.0),
          child: Container(
            height: 30.0,
            width: 2.0,
            color: Colors.grey,
          ),
        ),
        Text(weekDay(date.weekday) + ' ' + date.day.toString()),
      ],
    );
  }

  String weekDay(int value) {
    if (value == 1)
      return "Lunedì";
    else if (value == 2)
      return "Martedì";
    else if (value == 3)
      return "Mercoledì";
    else if (value == 4)
      return "Giovedì";
    else if (value == 5)
      return "Venerdì";
    else if (value == 6) return "Sabato";
    return "Domenica";
  }
}
