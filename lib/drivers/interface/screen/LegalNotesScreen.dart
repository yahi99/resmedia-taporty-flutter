import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/view/logo_view.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

class LegalNotesScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'LegalNotesScreen';
  @override
  String get route => ROUTE;

  @override
  _LegalNotesState createState() => _LegalNotesState();
}

class _LegalNotesState extends State<LegalNotesScreen> {
  var cookie = false;
  var conditions = false;
  var privacy = false;
  var _bodyHeight = 100.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: Padding(
          padding: const EdgeInsets.only(top: SPACE * 2),
      child:new ListView(
        shrinkWrap: true,
          children: <Widget>[
            new Column(
              children: <Widget>[
                new Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      child: new Text('Termini e condizioni'),
                    ),
                    new IconButton(
                        icon: new Icon((!conditions)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            conditions = !conditions;
                          });
                        }),
                  ],
                ),
                new AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: new Text('Termini e condizioni'),
                  height: (!conditions) ? 0.0 : 20.0,
                ),
              ],
            ),
            new Column(
              children: <Widget>[
                new Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      child: new Text('Privacy Policy'),
                    ),
                    new IconButton(
                        icon: new Icon((!privacy)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            privacy = !privacy;
                          });
                        }),
                  ],
                ),
                new AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: new Text('Privacy Policy'),
                  height: (!privacy) ? 0.0 : 20.0,
                ),
              ],
            ),
            new Column(
              children: <Widget>[
                new Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      child: new Text('Cookies Policy'),
                    ),
                    new IconButton(
                        icon: new Icon((!cookie)
                            ? Icons.keyboard_arrow_down
                            : Icons.keyboard_arrow_up),
                        onPressed: () {
                          setState(() {
                            //_bodyHeight = 100.0;
                            cookie = !cookie;
                          });
                        }),
                  ],
                ),
                new AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: new Text('Cookies Policy'),
                  height: (!cookie) ? 0.0 : 20.0,
                ),
              ],
            ),
          ].map((child) {
            return Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: SPACE * 2),
              child: child,
            );
          }).toList(),
        ),
        ),
    );
  }
}
