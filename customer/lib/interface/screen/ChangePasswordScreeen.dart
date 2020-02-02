import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';

class ChangePasswordScreen extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _prevPasswordController = TextEditingController();
  final userBloc = $Provider.of<UserBloc>();
  var isCorrect = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Account",
          style: theme.textTheme.body2.copyWith(color: Colors.white, fontSize: 18),
        ),
      ),
      body: StreamBuilder<UserModel>(
        stream: userBloc.outUser,
        builder: (_, userSnapshot) {
          if (!userSnapshot.hasData)
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
                        hintText: 'Password corrente',
                      ),
                      controller: _prevPasswordController,
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
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Nuova password',
                    ),
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'Inserire una nuova password.';
                      } else if (value.length < 6) return 'Password troppo corta.';
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
                        bool check = value == _passwordController.text;
                        if (value.isEmpty) {
                          return 'Confermare la password.';
                        }
                        if (!check) return 'Le password devono coincidere.';
                        return null;
                      },
                    ),
                  ),
                  RaisedButton(
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        try {
                          await userBloc.updatePassword(_prevPasswordController.text, _passwordController.text);
                          Toast.show("Password cambiata con successo!", context);
                          Navigator.pop(context);
                        } catch (error) {
                          if (error.code == 'ERROR_WEAK_PASSWORD')
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('La password deve contenere almeno 6 caratteri')));
                          else if (error.code == 'ERROR_WRONG_PASSWORD')
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('La password corrente è errata.')));
                          else
                            Scaffold.of(context).showSnackBar(SnackBar(content: Text('La password non è stata cambiata')));
                        }
                      }
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
      ),
    );
  }
}
