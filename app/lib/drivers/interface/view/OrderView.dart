import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/Order.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/main.dart';

class OrderView extends StatelessWidget {
  final OrderModel orderModel;

  OrderView({Key key, @required this.orderModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final sub = orderModel.subjects;
    return Order(
      isNear: (orderModel.preferredDeliveryTimestamp.difference(DateTime.now()).inMinutes > 0 && orderModel.preferredDeliveryTimestamp.difference(DateTime.now()).inMinutes <= 45) ? true : false,
      endTime: "driverOrderModel.endTime",
      date: "driverOrderModel.day",
      children: <Widget>[
        Padding(
          child: Divider(
            height: 4.0,
          ),
          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
        ),
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
    final textTheme = theme.textTheme;

    final title = subject == Subject.SUPPLIER ? "Fornitore" : "Cliente";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(bottom: 4.0),
            child: Text(
              title,
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold, color: red),
            ),
          ),
          Text(
            model.displayName,
            style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            model.address,
            style: textTheme.body1,
          ),
        ],
      ),
    );
  }
}
