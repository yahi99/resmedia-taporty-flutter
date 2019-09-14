import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/drivers/model/SubjectModel.dart';

//view per 'imprenditore

class SupplierView extends StatelessWidget {
  final SubjectModel supplier;

  const SupplierView({Key key, this.supplier}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var textButtonTheme = theme.textTheme.title.copyWith(color: Colors.white);
    var buttonColor = theme.accentColor;

    return Row(
      children: <Widget>[
        Text('Ordine N°'),
        Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                Text(
                  'Fornitore',
                  style:
                      TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                ),
                Text(supplier.title),
                Text(supplier.address)
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
                    onPressed: () {},
                    child: Text(
                      'Ritirata',
                      style: theme.textTheme.button,
                    ),
                  ),
                ),
              ]),
        ),
      ],
    );
  }
}
