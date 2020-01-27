import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final userBloc = $Provider.of<UserBloc>();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static final RegExp emailRegExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return _buildLoginForm();
  }

  _buildLoginForm() {
    return Material(
      child: Theme(
        child: Form(
          key: _formKey,
          child: LogoView(
            top: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
            ),
            children: [
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.email),
                  hintText: "Email",
                ),
                maxLines: 1,
                keyboardType: TextInputType.emailAddress,
                validator: (value) => value.isEmpty ? "Email vuota" : emailRegExp.hasMatch(value) ? null : "Email non valida",
                controller: _emailController,
              ),
              SizedBox(
                height: 12.0,
              ),
              TextFormField(
                decoration: InputDecoration(
                  hintText: "Password",
                  prefixIcon: const Icon(Icons.lock),
                ),
                maxLines: 1,
                keyboardType: TextInputType.text,
                validator: (value) => value.isEmpty ? "Password vuota" : value.length < 6 ? "Password troppo corta" : null,
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(
                height: 12.0,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: _isLoading
                          ? null
                          : () {
                              Navigator.pushNamed(context, "/signup");
                            },
                      child: FittedText('Registrati'),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: _isLoading
                          ? null
                          : () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  await userBloc.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                                  Navigator.popAndPushNamed(context, "/geolocalization");
                                } on NotACustomerException catch (err) {
                                  print(err);
                                  Toast.show("Non sei un cliente", context);
                                } catch (err) {
                                  if (err.code == "ERROR_INVALID_EMAIL")
                                    Toast.show("Email invalida", context);
                                  else if (err.code == "ERROR_WRONG_PASSWORD")
                                    Toast.show("Password errata", context);
                                  else if (err.code == "ERROR_USER_NOT_FOUND")
                                    Toast.show("Account inesistente", context);
                                  else
                                    Toast.show("Si è verificato un errore inaspettato", context);
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              }
                            },
                      child: FittedText('Accedi'),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 36.0,
              ),
              RaisedButton.icon(
                onPressed: _isLoading
                    ? null
                    : () async {
                        setState(() {
                          _isLoading = true;
                        });
                        try {
                          var result = await userBloc.signInWithGoogle();
                          if (result) Navigator.popAndPushNamed(context, "/geolocalization");
                        } on NotACustomerException catch (err) {
                          print(err);
                          Toast.show("Non sei un cliente", context);
                        } on NotRegisteredException catch (err) {
                          print(err);
                          Toast.show("Non sei registrato con questo account", context);
                        } on PlatformException catch (err) {
                          if (err.code != "sign_in_canceled") Toast.show("Si è verificato un errore inaspettato", context);
                        }

                        setState(() {
                          _isLoading = false;
                        });
                      },
                icon: Icon(FontAwesomeIcons.google),
                label: Text('Accedi con Google'),
              ),
              // TODO: Aggiungere Facebook come metodo di autenticazione
            ],
          ),
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
