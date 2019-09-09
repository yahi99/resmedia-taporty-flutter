import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/ChangePasswordScreeen.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/LegalNotesScreen.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

class EditScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'EditScreen';

  @override
  String get route => ROUTE;

  @override
  _EditState createState() => _EditState();
}

class _EditState extends State<EditScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Account"),
      ),
      body: SnackBarPage(),
    );
  }
}

class SnackBarPage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _passKey = GlobalKey<FormFieldState>();
  final _nameKey = GlobalKey<FormFieldState>();
  final _lastKey = GlobalKey<FormFieldState>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = UserBloc.of();
    return Scaffold(
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
              Padding(
                padding: EdgeInsets.only(top: 8.0),
              ),
              Text(snap.data.model.nominative),
              Text('Assisi'),
              const Divider(
                color: Colors.grey,
              ),
              Form(
                key: _formKey,
                child: Expanded(
                  child: ListViewSeparated(
                    separator: const Divider(
                      color: Colors.grey,
                    ),
                    children: <Widget>[
                      TextFormField(
                        key: _nameKey,
                        initialValue: temp[1],
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: _lastKey,
                        initialValue: temp[0],
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        key: _passKey,
                        initialValue: snap.data.model.email,
                        style: theme.textTheme.subhead,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Campo invalido';
                          }
                          return null;
                        },
                      ),
                      RaisedButton(
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            snap.data.userFb
                                .updateEmail(
                                    _passKey.currentState.value.toString())
                                .then((_) {
                              user.updateNominative(
                                  _nameKey.currentState.value.toString() +
                                      ' ' +
                                      _lastKey.currentState.value.toString(),
                                  _passKey.currentState.value.toString());
                              Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Cambiamenti eseguiti!'),
                              ));
                            }).catchError((error) {
                              print(error);
                              if (error is PlatformException) {
                                if (error.code == 'ERROR_INVALID_EMAIL') {
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text('E-mail non valida'),
                                  ));
                                }
                                if (error.code ==
                                    'ERROR_REQUIRES_RECENT_LOGIN') {
                                  snap.data.userFb.reload();
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content:
                                        Text('Rieffettua il login e riprova!'),
                                  ));
                                }
                              } else
                                Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text('Ci sono stati degli errori'),
                                ));
                            });
                          }
                        },
                        child: FittedText('Aggiorna dati'),
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
              ),
            ],
          );
        },
      ),
    );
  }
}
