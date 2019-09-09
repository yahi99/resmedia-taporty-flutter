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
    return Order(
      children: <Widget>[
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
              Text(
                "${model.title}",
                style: tt.subtitle,
              ),
              Text(
                "${model.address}",
                style: tt.body1,
              ),
            ],
          ),
        )
      ],
    );
  }
}
