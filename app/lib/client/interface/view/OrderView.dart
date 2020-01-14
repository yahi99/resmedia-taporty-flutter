import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/config/ColorTheme.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';

class OrderView extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "OrderView";

  String get route => ROUTE;

  final OrderModel order;

  const OrderView({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
  List<String> points = ['1', '2', '3', '4', '5'];

  String pointF, pointR;

  StreamController pointStreamF;
  StreamController pointStreamR;

  List<DropdownMenuItem> dropPoint = List<DropdownMenuItem>();

  @override
  void initState() {
    super.initState();
    pointStreamF = new StreamController<String>.broadcast();
    pointStreamR = new StreamController<String>.broadcast();
    for (int i = 0; i < points.length; i++) {
      dropPoint.add(DropdownMenuItem(
        child: Text(points[i]),
        value: points[i],
      ));
    }
    pointF = points[points.length - 1];
    pointR = points[points.length - 1];
  }

  @override
  void dispose() {
    super.dispose();
    pointStreamF.close();
    pointStreamR.close();
  }

  String toDate(String date) {
    final DateTime dateTime = DateTime.parse(date);
    return (dateTime.day.toString() + '/' + dateTime.month.toString() + '/' + dateTime.year.toString());
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Container(color: ColorTheme.STATE_COLORS[widget.order.state], width: 5, height: 120),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(DateTimeHelper.getDateTimeString(widget.order.creationTimestamp), style: TextStyle(fontSize: 14)),
                ),
                Text(
                  "Ordine #${widget.order.id}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                Text(translateOrderState(widget.order.state), style: TextStyle(fontSize: 14)),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                          children: [
                            WidgetSpan(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 2.0, right: 3),
                                child: Icon(FontAwesomeIcons.hamburger, size: 15),
                              ),
                            ),
                            TextSpan(
                              text: widget.order.productCount.toString(),
                              style: theme.textTheme.body1.copyWith(fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              WidgetSpan(
                                child: Padding(
                                  padding: const EdgeInsets.only(bottom: 2.0, right: 3),
                                  child: Icon(FontAwesomeIcons.euroSign, size: 15),
                                ),
                              ),
                              TextSpan(
                                text: widget.order.totalPrice.toStringAsFixed(2),
                                style: theme.textTheme.body1.copyWith(fontSize: 15),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
        Center(child: Icon(Icons.arrow_forward_ios, size: 13)),
      ],
    );
  }
}
