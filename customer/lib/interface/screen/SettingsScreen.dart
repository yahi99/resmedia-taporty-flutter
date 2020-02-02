import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsState createState() => _SettingsState();
}

class _SettingsState extends State<SettingsScreen> {
  final userBloc = $Provider.of<UserBloc>();

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return StreamBuilder<UserModel>(
      stream: userBloc.outUser,
      builder: (ctx, userSnapshot) {
        if (!userSnapshot.hasData) return Center(child: CircularProgressIndicator());
        return Scaffold(
          appBar: AppBar(
            title: Text(
              "Impostazioni",
              style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(top: 12.0 * 2),
            child: ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Text('RICEVI AGGIORNAMENTI TRAMITE'),
                  ],
                ),
                /*Row(
                  children: <Widget>[
                    Expanded(child: Text('Invia dati ordine per E-mail')),
                    Switch(
                      onChanged: (value) {
                        user.updateNotifyEmail(value);
                      },
                      value: (userSnapshot.data.notifyEmail == null) ? false : userSnapshot.data.notifyEmail,
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
                      value: (userSnapshot.data.notifyEmail == null) ? false : userSnapshot.data.notifySms,
                    ),
                  ],
                ),*/
                Row(
                  children: <Widget>[
                    Expanded(child: Text('Notifiche App')),
                    Switch(
                      onChanged: (value) {
                        userBloc.updateNotifyApp(value);
                      },
                      value: (userSnapshot.data.notifyApp == null) ? false : userSnapshot.data.notifyApp,
                    ),
                  ],
                ),
                /*Row(
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
                      value: (userSnapshot.data.offersEmail == null) ? false : userSnapshot.data.offersEmail,
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
                      value: (userSnapshot.data.offersSms == null) ? false : userSnapshot.data.offersSms,
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
                      value: (userSnapshot.data.offersApp == null) ? false : userSnapshot.data.offersApp,
                    ),
                  ],
                ),*/
              ].map((child) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2),
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
