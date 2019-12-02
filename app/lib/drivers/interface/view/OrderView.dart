import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/Order.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';

class OrderView extends StatelessWidget {
  final DriverOrderModel model;

  OrderView({Key key, @required this.model}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sub = model.subjects;
    final temp=model.endTime.split(':');
    final day=DateTime.parse(model.day);
    final time=DateTime(day.year,day.month,day.day,int.parse(temp.elementAt(0)),int.parse(temp.elementAt(1)));
    return Order(
      isNear:(time.difference(DateTime.now()).inMinutes>0 && time.difference(DateTime.now()).inMinutes <=45)?true:false,
      endTime: model.endTime,
      date: model.day,
      children: <Widget>[
        Padding(child:Divider(height: 4.0,),padding: EdgeInsets.only(top:8.0,bottom: 8.0),),
        Expanded(
          child: SubjectVoid(
            model: sub[0],
          ),
        ),
        Center(
            child: Icon(
          Icons.arrow_forward,
          size: 32,
        )),
        Expanded(
          child: SubjectVoid(
            model: sub[1],
            subject: Subject.RECEIVER,
          ),
        ),
      ],
    );
  }
}

enum Subject {
  SUPPLIER,
  RECEIVER,
}

class SubjectVoid extends StatelessWidget {
  final SubjectModel model;

  final Subject subject;

  SubjectVoid({
    Key key,
    @required this.model,
    this.subject: Subject.SUPPLIER,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final title = subject == Subject.SUPPLIER ? "Fornitore" : "Cliente";

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '$title',
          style: tt.subhead,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                child: Text(
                  "${(model.address.length > 30) ? model.address.substring(0, 28) + '\n' + model.address.substring(28) : model.address}",
                  style: tt.body1,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
