import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:toast/toast.dart';

class ChangePasswordScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = 'ChangePasswordScreen';

  @override
  String get route => ROUTE;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
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
  final _passKeyB = GlobalKey<FormFieldState>();
  var isCorrect = false;

  Future<FirebaseUser> _handleSignIn(String email, value) async {
    final FirebaseAuth _fAuth = FirebaseAuth.instance;
    return (await _fAuth.signInWithEmailAndPassword(email: email, password: value)).user;
  }

  @override
  Widget build(BuildContext context) {
    final user = UserBloc.of();
    return StreamBuilder<User>(
      stream: user.outUser,
      builder: (ctx, snap) {
        if (!snap.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );

        return Scaffold(
          body: Form(
            key: _formKey,
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 12.0 * 2),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Password',
                    ),
                    key: _passKeyB,
                    obscureText: true,
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Campo invalido';
                      } else if (!isCorrect) return 'Password non corretta';
                      return null;
                    },
                  ),
                ),
                const Divider(
                  color: Colors.grey,
                ),
                TextFormField(
                  key: _passKey,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Nuova password',
                  ),
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Campo invalido';
                    } else if (value.length < 4) return 'Deve contenere almeno 4 caratteri';
                    return null;
                  },
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: TextFormField(
                    decoration: InputDecoration(
                      hintText: 'Conferma nuova password',
                    ),
                    obscureText: true,
                    validator: (value) {
                      bool check = value == _passKey.currentState.value;
                      if (value.isEmpty) {
                        return 'Campo invalido';
                      }
                      if (!check) return 'Le password devono coincidere';
                      return null;
                    },
                  ),
                ),
                RaisedButton(
                  onPressed: () async {
                    if (_passKeyB.currentState.value.toString().isNotEmpty)
                      await _handleSignIn(snap.data.model.email, _passKeyB.currentState.value.toString()).then((result) {
                        if (result != null && result.uid == snap.data.userFb.uid) isCorrect = true;
                        if (_formKey.currentState.validate()) {
                          snap.data.userFb.updatePassword(_passKey.currentState.value.toString()).then((_) {
                            Toast.show("Password cambiata con successo!", context);
                            EasyRouter.pop(context);
                          }).catchError((error) {
                            print(error);
                            if (error is PlatformException) {
                              if (error.code == 'ERROR_WEAK_PASSWORD')
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('La password deve contenere almeno 6 caratteri')));
                              else
                                Scaffold.of(context).showSnackBar(SnackBar(content: Text('La password non è stata cambiata')));
                            }
                          });
                        }
                      }).catchError((error) {
                        print(error);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('La password potrebbe essere sbagliata'),
                        ));
                      });
                  },
                  child: FittedText('Aggiorna password'),
                ),
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
