import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/drivers/interface/screen/ChangePasswordScreeen.dart';
import 'package:mobile_app/drivers/interface/screen/EditScreen.dart';
import 'package:mobile_app/drivers/interface/screen/LegalNotesScreen.dart';
import 'package:mobile_app/drivers/interface/screen/OrderScreen.dart';
import 'package:mobile_app/drivers/interface/screen/SettingsScreen.dart';
import 'package:mobile_app/interface/screen/LoginScreen.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

class AccountScreenDriver extends StatelessWidget implements WidgetRoute {
  static const ROUTE = 'AccountScreenDriver';
  String get route => ROUTE;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = UserBloc.of();
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: IconButton(icon: Icon(Icons.exit_to_app),
          onPressed: (){
            user.logout().then((onValue){
              EasyRouter.pushAndRemoveAll(context, LoginScreen());
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () => {
              EasyRouter.push(context,EditScreen())
            },
            icon: Icon(Icons.mode_edit),
          )
        ],
        title: Text("Account"),
      ),
      body: StreamBuilder<User>(
        stream: user.outUser,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          var temp = snap.data.model.nominative.split(' ');
          return Column(
            children: <Widget>[
              Stack(
                  alignment: Alignment.topCenter,
                  children: <Widget>[
                    AspectRatio(
                      aspectRatio: 3,
                      child: Image.asset(
                        "assets/img/home/etnici.png",
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 25.0),
                      child: new Container(
                        width: 190.0,
                        height: 190.0,
                        decoration: new BoxDecoration(
                            shape: BoxShape.circle,
                            image: new DecorationImage(
                                image: new AssetImage(
                                    'assets/img/home/fotoprofilo.jpg'))),
                      ),
                    ),
                  ],
                ),
              Padding(padding: EdgeInsets.only(top: 8.0),),
              Text(snap.data.model.nominative),
              Text('Assisi'),
              const Divider(
                color: Colors.grey,
              ),
              Expanded(
                child: ListViewSeparated(
                  separator: const Divider(
                    color: Colors.grey,
                  ),
                  children: <Widget>[
                    Text(
                      temp[1],
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      temp[0],
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      snap.data.model.email,
                      style: theme.textTheme.subhead,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.insert_drive_file),
                        FlatButton(
                          child: Text('Lista ordini',style: theme.textTheme.subhead),
                          onPressed: () => {
                            EasyRouter.push(context, OrderListScreen())
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.insert_drive_file),
                        FlatButton(
                          child: Text('Note legali',style: theme.textTheme.subhead),
                          onPressed: () => {
                            EasyRouter.push(context, LegalNotesScreen())
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.lock_outline),
                        FlatButton(
                          child: Text('Cambia password',style: theme.textTheme.subhead),
                          onPressed: () => {
                            EasyRouter.push(context, ChangePasswordScreen())
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.settings),
                        FlatButton(
                          child: Text('Settings',style: theme.textTheme.subhead),
                          onPressed: () => {
                            EasyRouter.push(context, SettingsScreen())
                          },
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
              const Divider(
                color: Colors.grey,
              ),
            ],
          );
        },
      ),
    );
  }
}
