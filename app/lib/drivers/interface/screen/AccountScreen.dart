import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/BecomeDriverScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/BecomeRestaurantScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/ChangePasswordScreeen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/EditScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/LegalNotesScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/OrderScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/SettingsScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/LoginScreen.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';

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
        leading: IconButton(
          icon: Icon(Icons.exit_to_app),
          onPressed: () {
            user.logout().then((onValue) {
              EasyRouter.pushAndRemoveAll(context, LoginScreen());
            });
          },
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            onPressed: () => {EasyRouter.push(context, EditScreen())},
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
          print(snap.data.model.isDriver);
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
                    child: Container(
                      width: 190.0,
                      height: 190.0,
                      child: Container(
                        width: double.infinity,
                        height: double.infinity,
                        child: (snap.data.userFb.photoUrl != null)?CircleAvatar(
                          backgroundImage:CachedNetworkImageProvider(
                                  snap.data.userFb.photoUrl)
                        ):Container(
                          child: Center(
                            child: AutoSizeText(
                                "\n\n\n Nessun'immagine del profilo selezionata",
                                textAlign: TextAlign.center),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
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
                      snap.data.model.nominative,
                      style: theme.textTheme.subhead,
                    ),
                    Text(
                      snap.data.model.email,
                      style: theme.textTheme.subhead,
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.directions_car),
                        FlatButton(
                          child:
                          Text('Diventa un Fattorino', style: theme.textTheme.subhead),
                          onPressed: () =>
                          {EasyRouter.push(context, BecomeDriverScreen())},
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.directions_car),
                        FlatButton(
                          child:
                          Text('Diventa un ristoratore', style: theme.textTheme.subhead),
                          onPressed: () =>
                          {EasyRouter.push(context, BecomeRestaurantScreen())},
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.shopping_cart),
                        FlatButton(
                          child: Text('Lista ordini',
                              style: theme.textTheme.subhead),
                          onPressed: () async {
                            await OrdersBloc.of().setUserStream();
                            EasyRouter.push(context, OrderListScreen());
                          },
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.insert_drive_file),
                        FlatButton(
                          child: Text('Note legali',
                              style: theme.textTheme.subhead),
                          onPressed: () =>
                              {EasyRouter.push(context, LegalNotesScreen())},
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Icon(Icons.lock_outline),
                        FlatButton(
                          child: Text('Cambia password',
                              style: theme.textTheme.subhead),
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
                          child:
                              Text('Settings', style: theme.textTheme.subhead),
                          onPressed: () =>
                              {EasyRouter.push(context, SettingsScreen())},
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
