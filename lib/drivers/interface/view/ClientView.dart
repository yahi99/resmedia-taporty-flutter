import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/drivers/model/SubjectModel.dart';

//visualizzazione cliente
// ignore: must_be_immutable
class ClientView extends StatelessWidget {

  SubjectModel client;


  @override
  Widget build(BuildContext context) {
var theme = Theme.of(context);
    var textButtonTheme = theme.textTheme.title.copyWith(color: Colors.white);
    var buttonColor =  theme.accentColor;

    return Row(
      
      children: <Widget>[
        Text('Ordine N°'),
        new Column(
          children: <Widget>[
            new Stack(
              alignment: Alignment.centerLeft,
              children: <Widget>[
                new Text('Fornitore', style: new TextStyle(fontSize: 13, fontWeight: FontWeight.bold),),
                new Text(client.title),
                new Text(client.address)
              ],
            )
          ],
        ),
        new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton(onPressed: () {

              },
              color: buttonColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
              child: Text('Chiama', style: textButtonTheme,),

            )

          ],
        ),
        Expanded(
          child:Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: RaisedButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
                padding: const EdgeInsets.all(10.0),
                onPressed: () {

                },
                color: theme.primaryColor,
                child: Text(
                'Start',
                style: theme.textTheme.button,
                ),
              ),
            ),
            Expanded(
              child: RaisedButton(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25.0)),
              padding: const EdgeInsets.all(10.0),
              color:theme.secondaryHeaderColor,
              onPressed: () {
              
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
    ]
    );
  }
}