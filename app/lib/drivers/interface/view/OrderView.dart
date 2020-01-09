import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/widget/Order.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/main.dart';

class OrderView extends StatelessWidget {
  final OrderModel order;

  OrderView({Key key, @required this.order}) : super(key: key);

  final AutoSizeGroup nameGroup = AutoSizeGroup();
  final AutoSizeGroup addressGroup = AutoSizeGroup();

  @override
  Widget build(BuildContext context) {
    /*return Order(
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
    );*/
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        "Fornitore",
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.RED, fontSize: 12),
                      ),
                    ),
                    AutoSizeText(
                      order.restaurantName,
                      group: nameGroup,
                      minFontSize: 14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      order.restaurantAddress,
                      group: addressGroup,
                      minFontSize: 10,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6.0),
                      child: Text(
                        "Cliente",
                        style: TextStyle(fontWeight: FontWeight.bold, color: ColorTheme.RED, fontSize: 12),
                      ),
                    ),
                    AutoSizeText(
                      order.customerName,
                      group: nameGroup,
                      minFontSize: 14,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold),
                    ),
                    AutoSizeText(
                      order.customerAddress,
                      group: addressGroup,
                      minFontSize: 10,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
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
              style: textTheme.subhead.copyWith(fontWeight: FontWeight.bold, color: ColorTheme.RED),
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
