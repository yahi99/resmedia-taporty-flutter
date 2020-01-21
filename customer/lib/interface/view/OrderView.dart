import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';

class OrderView extends StatefulWidget {
  final OrderModel order;

  const OrderView({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _OrderViewState createState() => _OrderViewState();
}

class _OrderViewState extends State<OrderView> {
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
