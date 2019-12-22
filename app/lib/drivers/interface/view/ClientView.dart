import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';

//visualizzazione cliente
// ignore: must_be_immutable
class ClientView extends StatefulWidget {
  final DriverOrderModel orderModel;
  final SubjectModel model;

  ClientView({Key key, @required this.model, @required this.orderModel})
      : super(key: key);

  @override
  _StateClientView createState() => _StateClientView();
}

class _StateClientView extends State<ClientView> {
  void _askPermission(BuildContext context, String state) async {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text((state == 'PICKED_UP')
                      ? 'Sei sicuro di avere ritirato il pacco?'
                      : 'Sei sicuro di aver consegnato il pacco?'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.check),
                        onPressed: () async {
                          EasyRouter.pop(context);
                          Database().updateState(
                              state,
                              widget.orderModel.uid,
                              widget.orderModel.id,
                              widget.orderModel.restId,
                              (await UserBloc.of().outUser.first).model.id);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textButtonTheme = theme.textTheme.title.copyWith(color: Colors.white);
    var buttonColor = theme.accentColor;

    return Row(children: <Widget>[
      Text('Ordine N°'),
      Column(
        children: <Widget>[
          Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Text(
                'Fornitore',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Text(widget.model.title),
              Text(widget.model.address)
            ],
          )
        ],
      ),
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RaisedButton(
            onPressed: () {},
            color: buttonColor,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child: Text(
              'Chiama',
              style: textButtonTheme,
            ),
          )
        ],
      ),
      Expanded(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                padding: const EdgeInsets.all(10.0),
                onPressed: () {},
                color: theme.primaryColor,
                child: Text(
                  'Start',
                  style: theme.textTheme.button,
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25.0)),
                padding: const EdgeInsets.all(10.0),
                color: theme.secondaryHeaderColor,
                onPressed: () {
                  _askPermission(context, 'DONE');
                },
                child: Text(
                  'Consegnata',
                  style: theme.textTheme.button,
                ),
              ),
            ),
          ],
        ),
      ),
    ]);
  }
}
