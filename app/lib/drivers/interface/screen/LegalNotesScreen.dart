import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
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
        child: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Termini e condizioni'),
                    ),
                    IconButton(
                        icon: Icon((!conditions)
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
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Termini e condizioni'),
                  height: (!conditions) ? 0.0 : 20.0,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Privacy Policy'),
                    ),
                    IconButton(
                        icon: Icon((!privacy)
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
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Privacy Policy'),
                  height: (!privacy) ? 0.0 : 20.0,
                ),
              ],
            ),
            Column(
              children: <Widget>[
                Row(
                  //mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Expanded(
                      child: Text('Cookies Policy'),
                    ),
                    IconButton(
                        icon: Icon((!cookie)
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
                AnimatedContainer(
                  alignment: Alignment.topLeft,
                  curve: Curves.easeInOut,
                  duration: const Duration(milliseconds: 500),
                  child: Text('Cookies Policy'),
                  height: (!cookie) ? 0.0 : 20.0,
                ),
              ],
            ),
          ].map((child) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: SPACE * 2),
              child: child,
            );
          }).toList(),
        ),
      ),
    );
  }
}
