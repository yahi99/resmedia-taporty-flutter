import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/FittedText.dart';
import 'package:resmedia_taporty_flutter/common/interface/widget/ListViewSeparated.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class EditScreen extends StatefulWidget {
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
          return StreamBuilder<UserModel>(
              stream: Database().getUser(snap.data.userFb),
              builder: (ctx, userSnapshot) {
                if (snap.hasData && userSnapshot.hasData) {
                  if (userSnapshot.data.type != 'user' && userSnapshot.data.type != null) {
                    return RaisedButton(
                      child: Text('Sei stato disabilitato clicca per fare logout'),
                      onPressed: () {
                        UserBloc.of().logout();
                        Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                      },
                    );
                    //Navigator.pushNamedAndRemoveUntil(context, "/login", (Route<dynamic> route) => false);
                  }
                  //var temp = snap.data.model.nominative.split(' ');
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
                                child: (userSnapshot.data.imageUrl != null)
                                    ? CircleAvatar(backgroundImage: CachedNetworkImageProvider(userSnapshot.data.imageUrl))
                                    : Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage("assets/img/default_profile_photo.jpg"),
                                      ),
                              ),
                            ),
                          )
                        ],
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.0),
                      ),
                      (userSnapshot.data.nominative != null) ? Text(userSnapshot.data.nominative) : Container(),
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
                                initialValue: userSnapshot.data.nominative,
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
                                initialValue: userSnapshot.data.email,
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
                                    snap.data.userFb.updateEmail(_passKey.currentState.value.toString()).then((_) {
                                      user.updateNominative(_nameKey.currentState.value.toString(), _passKey.currentState.value.toString());
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
                                        if (error.code == 'ERROR_REQUIRES_RECENT_LOGIN') {
                                          snap.data.userFb.reload();
                                          Scaffold.of(context).showSnackBar(SnackBar(
                                            content: Text('Rieffettua il login e riprova!'),
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
                                padding: const EdgeInsets.symmetric(horizontal: 12.0 * 2),
                                child: child,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              });
        },
      ),
    );
  }
}
