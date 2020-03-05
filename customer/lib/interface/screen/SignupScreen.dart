import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:toast/toast.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _userBloc = $Provider.of<UserBloc>();

  final TextEditingController _emailController = new TextEditingController();
  final TextEditingController _passwordController = new TextEditingController();
  final TextEditingController _confirmPasswordController = new TextEditingController();
  final TextEditingController _nameController = new TextEditingController();
  final _formKey = GlobalKey<FormState>();

  static final RegExp emailRegExp = new RegExp(r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,253}[a-zA-Z0-9])?)*$");

  bool _privacyChecked;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _privacyChecked = false;
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Scaffold(
            body: ListView(
              shrinkWrap: true,
              children: <Widget>[
                AutoSizeText('Privacy Policy'),
                RaisedButton(
                  child: Text('  Chiudi  '),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Theme(
        child: LogoView(
          logoHeight: 64,
          top: FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              Icons.lock_outline,
              color: Colors.white,
            ),
          ),
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        decoration: InputDecoration(hintText: "Nominativo", prefixIcon: const Icon(Icons.account_circle)),
                        maxLines: 1,
                        validator: (value) => value.isEmpty ? "Nome vuoto" : null,
                        controller: _nameController,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
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
                      TextFormField(
                        decoration: InputDecoration(
                          hintText: "Conferma password",
                          hintStyle: TextStyle(fontSize: 15, color: Colors.grey),
                          prefixIcon: const Icon(Icons.lock),
                        ),
                        maxLines: 1,
                        keyboardType: TextInputType.text,
                        validator: (value) => value != _passwordController.text ? "Le password non corrispondono" : null,
                        controller: _confirmPasswordController,
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      Row(
                        children: <Widget>[
                          Checkbox(
                            value: _privacyChecked,
                            onChanged: (value) {
                              setState(() {
                                _privacyChecked = value;
                              });
                            },
                          ),
                          FlatButton(
                            child: Text(
                              'Privacy Policy',
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              _showPolicyDialog(context);
                            },
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      RaisedButton(
                        child: FittedText('Registrati'),
                        onPressed: !_privacyChecked && !_isLoading
                            ? null
                            : () async {
                                if (_formKey.currentState.validate()) {
                                  setState(() {
                                    _isLoading = true;
                                  });

                                  try {
                                    await _userBloc.createUserWithEmailAndPassword(_nameController.text, _emailController.text, _passwordController.text);
                                    Navigator.popAndPushNamed(context, "/geolocalization");
                                  } on PlatformException catch (err) {
                                    if (err.code == "ERROR_INVALID_EMAIL")
                                      Toast.show("Email invalida", context);
                                    else if (err.code == "ERROR_EMAIL_ALREADY_IN_USE")
                                      Toast.show("Email non disponibile", context);
                                    else {
                                      print(err);
                                      Toast.show("Si è verificato un errore inaspettato", context);
                                    }
                                  } catch (err) {
                                    print(err);
                                    Toast.show("Si è verificato un errore inaspettato", context);
                                  }

                                  setState(() {
                                    _isLoading = false;
                                  });
                                }
                              },
                      ),
                      SizedBox(
                        height: 12.0,
                      ),
                      RaisedButton.icon(
                        onPressed: !_privacyChecked && !_isLoading
                            ? null
                            : () async {
                                setState(() {
                                  _isLoading = true;
                                });
                                try {
                                  var result = await _userBloc.signUpWithGoogle();
                                  if (result) Navigator.popAndPushNamed(context, "/geolocalization");
                                } catch (err) {
                                  print(err);
                                  Toast.show("Si è verificato un errore inaspettato", context);
                                }

                                setState(() {
                                  _isLoading = false;
                                });
                              },
                        icon: Icon(FontAwesomeIcons.google),
                        label: Text('Registrati con Google'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
