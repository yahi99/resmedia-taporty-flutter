import 'dart:async';

import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/DetailedOrderUser.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:toast/toast.dart';

class TypeOrderView extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "TypeOrderView";

  String get route => ROUTE;

  final OrderModel order;

  const TypeOrderView({
    Key key,
    this.order,
  }) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<TypeOrderView> {
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
    return Slidable(
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: <Widget>[
        IconSlideAction(
          icon: Icons.close,
          color: theme.accentColor,
          onTap: () async {
            if (widget.order.state != OrderState.CANCELLED)
              Database().deleteOrder(widget.order, (await UserBloc.of().outUser.first).model.id).then((value) {
                Toast.show('Ordine cancellato!', context);
              });
            else {
              Toast.show('Ordine già cancellato!', context);
            }
          },
        )
      ],
      child: InkWell(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: 186,
                  minHeight: 48,
                ),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text('Prezzo totale: ', style: theme.textTheme.subtitle),
                              Text(widget.order.newTotalPrice.toStringAsFixed(2) + ' €'),
                            ],
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              /*Text('Data Ordine: ',
                                  style: theme.textTheme.subtitle),
                              Text(widget.model.timeR),*/
                              Text('Data ed ora consegna: ', style: theme.textTheme.subtitle),
                              Text(DateTimeHelper.getDateTimeString(widget.order.preferredDeliveryTimestamp)),
                              Text('Stato Ordine: ', style: theme.textTheme.subtitle),
                              Text(translateOrderState(widget.order.state)),
                            ],
                          ),
                        ],
                      ),
                      (widget.order.state == OrderState.DELIVERED && widget.order.isReviewed == null)
                          ? RaisedButton(
                              child: Text('Lascia una Recensione'),
                              onPressed: () {
                                _addReview(context);
                              },
                            )
                          : Container(),
                    ],
                  ),
                  padding: EdgeInsets.all(4.0),
                  decoration: BoxDecoration(
                      border: Border.all(
                    color: (widget.order.preferredDeliveryTimestamp.difference(DateTime.now()).inMinutes > 0 && widget.order.preferredDeliveryTimestamp.difference(DateTime.now()).inMinutes <= 45)
                        ? Colors.red
                        : Colors.black,
                  )),
                ),
              ),
            ),
          ],
        ),
        onTap: () {
          EasyRouter.push(
              context,
              DetailedOrderUser(
                order: widget.order,
              ));
        },
      ),
    );
  }
}
