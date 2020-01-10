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

  final _restKey = new GlobalKey<FormFieldState>();
  final _driverKey = new GlobalKey<FormFieldState>();

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

  // TODO: Da usare
  void _addReview(BuildContext context) {
    showDialog(
        context: context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Container(
              child: ListView(
                physics: AlwaysScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Padding(
                        child: Text('Ristorante'),
                        padding: EdgeInsets.only(bottom: 12.0 * 2, right: 12.0 * 2),
                      ),
                      StreamBuilder(
                        stream: pointStreamR.stream,
                        builder: (ctx, snap) {
                          return Padding(
                            child: DropdownButton(
                              //key: _dropKey,
                              value: (!snap.hasData) ? pointR : snap.data,
                              onChanged: (value) {
                                print(value);
                                pointR = value;
                                pointStreamR.add(value);
                              },
                              items: dropPoint,
                            ),
                            padding: EdgeInsets.only(bottom: 12.0 * 2),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    child: TextFormField(
                      key: _restKey,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.length == 0) {
                          return 'Inserisci valutazione';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Come è stata la tua esperienza?",
                      ),
                      maxLines: 10,
                      minLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        child: Text('Fattorino'),
                        padding: EdgeInsets.only(bottom: 12.0 * 2, right: 12.0 * 2),
                      ),
                      StreamBuilder(
                        stream: pointStreamF.stream,
                        builder: (ctx, snap) {
                          return Padding(
                            child: DropdownButton(
                              //key: _dropKey,
                              value: (!snap.hasData) ? pointF : snap.data,
                              onChanged: (value) {
                                print(value);
                                pointF = value;
                                pointStreamF.add(value);
                              },
                              items: dropPoint,
                            ),
                            padding: EdgeInsets.only(bottom: 12.0 * 2),
                          );
                        },
                      ),
                    ],
                  ),
                  Padding(
                    child: TextFormField(
                      key: _driverKey,
                      textInputAction: TextInputAction.done,
                      validator: (value) {
                        if (value.length == 0) {
                          return 'Inserisci valutazione';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        hintText: "Come è stata la tua esperienza?",
                      ),
                      maxLines: 10,
                      minLines: 5,
                      keyboardType: TextInputType.text,
                    ),
                    padding: EdgeInsets.all(8.0),
                  ),
                  RaisedButton(
                    child: Text('Invia la recensione'),
                    onPressed: () async {
                      final user = (await UserBloc.of().outUser.first);
                      if (_driverKey.currentState.validate() && _restKey.currentState.validate()) {
                        Database().pushRestaurantReview(widget.order.restaurantId, int.parse(pointR), _restKey.currentState.value, widget.order.id, user.model.id, user.model.nominative);
                        Database().pushDriverReview(widget.order.driverId, int.parse(pointF), _driverKey.currentState.value, user.model.id, widget.order.id, user.model.nominative);
                        Database().setOrderToReviewed(user.model.id, widget.order.id);
                        EasyRouter.pop(context);
                      }
                    },
                  )
                ],
              ),
              height: 400,
              width: 200,
            ),
          );
        });
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
