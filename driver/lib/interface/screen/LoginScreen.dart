import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/ShiftBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:toast/toast.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final driverBloc = $Provider.of<DriverBloc>();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static final RegExp emailRegExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  bool _isLoading = false;

  Future<void> setDriver(String uid) async {
    final userBloc = $Provider.of<DriverBloc>();
    final orderBloc = $Provider.of<OrderBloc>();
    await orderBloc.setDriverStream((await userBloc.outFirebaseUser.first).uid);
    final shiftBloc = $Provider.of<ShiftBloc>();
    await shiftBloc.setDriverStream((await userBloc.outFirebaseUser.first).uid);
  }

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
                          : () async {
                              if (_formKey.currentState.validate()) {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  var authResult = await driverBloc.signInWithEmailAndPassword(_emailController.text, _passwordController.text);
                                  await setDriver(authResult.user.uid);
                                  Navigator.popAndPushNamed(context, "/home");
                                } on NotADriverException catch (err) {
                                  print(err);
                                  Toast.show("Non sei un fattorino", context);
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
            ],
          ),
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
