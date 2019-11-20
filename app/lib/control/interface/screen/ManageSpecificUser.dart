import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/UsersBloc.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/HomeScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageSpecificUser extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageSpecificUser";

  final UserModel user;

  String get route => ROUTE;

  ManageSpecificUser({@required this.user});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageSpecificUser> {

  StreamController typeStream;

  String type;

  List<DropdownMenuItem> dropType = List<DropdownMenuItem>();

  List<String> types=['user','restaurant','control','disabled'];

  _showPositionDialog(BuildContext context) {
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
                  Text(
                    "Sicuro di volere fare un reset della mail?",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          EasyRouter.pop(context);
                        },
                        textColor: Colors.white,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          FirebaseAuth.instance.sendPasswordResetEmail(email: widget.user.email).then((value) {
                            Toast.show('E-mail inviata', context);
                            EasyRouter.pop(context);
                          });
                        },
                        color: Colors.green,
                        textColor: Colors.white,
                        child: Text(
                          "Consenti",
                        ),
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
  void initState(){
    super.initState();
    typeStream=new StreamController<String>.broadcast();
    for(int i=0;i<types.length;i++){
      dropType.add(DropdownMenuItem(
        child: Text(types[i]),
        value: types[i],
      ));
    }
    type=widget.user.type;
  }

  @override
  void dispose() {
    super.dispose();
    typeStream.close();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestisci utente"),
          actions: <Widget>[

          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: <Widget>[
            Row(
              children: <Widget>[
                Text('Reset e-mail'),
                RaisedButton(
                  child: Text('Reset'),
                  onPressed: (){
                    _showPositionDialog(context);
                  },
                )
              ],
            ),
            Row(
              children: <Widget>[
                Text('Tipologia utente: '+widget.user.type),
                StreamBuilder(
                  stream: typeStream.stream,
                  builder: (ctx,snap){
                    return Padding(
                      child:DropdownButton(
                        //key: _dropKey,
                        value: (!snap.hasData)
                            ? types.elementAt(0)
                            : snap.data,
                        onChanged: (value) {
                          print(value);
                          type = value;
                          typeStream.add(value);
                        },
                        items: dropType,
                      ),
                      padding: EdgeInsets.only(bottom: SPACE * 2),
                    );
                  },
                ),
                RaisedButton(
                  child: Text('Cambia'),
                  onPressed: (){
                    Database().editUser(widget.user.id, type);
                  },
                )
              ],
            )
          ],
        ),
        );
  }
}
