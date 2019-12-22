import 'package:easy_route/easy_route.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class SettingsScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'SettingsScreen';

  @override
  String get route => ROUTE;

  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final user = UserBloc.of();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User>(
      stream: user.outUser,
      builder: (ctx, snap) {
        if (!snap.hasData) return Center(child: CircularProgressIndicator());
        return Scaffold(
          appBar: AppBar(
            title: Text("Settings"),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: SPACE * 2),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('RICEVI AGGIORNAMENTI TRAMITE'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Invia dati ordine per E-mail')),
                    Switch(
                      onChanged: (value) {
                        user.updateNotifyEmail(value);
                      },
                      value: (snap.data.model.notifyEmail == null)
                          ? false
                          : snap.data.model.notifyEmail,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Invia dati ordine per SMS')),
                    Switch(
                      onChanged: (value) {
                        user.updateNotifySms(value);
                      },
                      value: (snap.data.model.notifyEmail == null)
                          ? false
                          : snap.data.model.notifySms,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Notifiche App')),
                    Switch(
                      onChanged: (value) {
                        user.updateNotifyApp(value);
                      },
                      value: (snap.data.model.notifyApp == null)
                          ? false
                          : snap.data.model.notifyApp,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Text('RICEVI OFFERTE E NEWS TRAMITE'),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('E-mail')),
                    Switch(
                      onChanged: (value) {
                        user.updateOffersEmail(value);
                      },
                      value: (snap.data.model.offersEmail == null)
                          ? false
                          : snap.data.model.offersEmail,
                    ),
                  ],
                ),
                Divider(
                  color: Colors.grey,
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('SMS')),
                    Switch(
                      onChanged: (value) {
                        user.updateOffersSms(value);
                      },
                      value: (snap.data.model.offersSms == null)
                          ? false
                          : snap.data.model.offersSms,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Notifiche App')),
                    Switch(
                      onChanged: (value) {
                        user.updateOffersApp(value);
                      },
                      value: (snap.data.model.offersApp == null)
                          ? false
                          : snap.data.model.offersApp,
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
      },
    );
  }
}
