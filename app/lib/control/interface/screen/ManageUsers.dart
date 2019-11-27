import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

import 'ManageSpecificUser.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ManageUsers extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "ManageUsersScreen";

  String get route => ROUTE;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<ManageUsers> {
  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Scaffold(
        appBar: AppBar(
          title: Text("Gestisci utenti"),
          actions: <Widget>[],
        ),
        body: StreamBuilder<List<UserModel>>(
          stream: UsersBloc.of().outRequests,
          builder: (ctx, snap) {
            if (!snap.hasData)
              return Center(
                child: CircularProgressIndicator(),
              );
            if(snap.data.length>0)
            return ListView.separated(
                shrinkWrap: true,
                itemCount: snap.data.length,
                separatorBuilder: (ctx, index) {
                  return Divider(
                    height: 4.0,
                  );
                },
                itemBuilder: (ctx,index){
                  final user=snap.data.elementAt(index);
                  return InkWell(
                    child: Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Padding(
                                  child: Text(
                                    user.nominative,
                                    style: theme.textTheme.subtitle,
                                  ),
                                  padding: EdgeInsets.all(4.0),
                                ),
                                Padding(
                                  child: Text(user.email),
                                  padding: EdgeInsets.all(4.0),
                                ),
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                    onTap: ()async{
                      if(user.type!='admin') EasyRouter.push(context,ManageSpecificUser(user:user));
                    },
                  );
            },

                );
            return Padding(child: Text('Non ci sono utenti'),);
          },
        ));
  }
}
