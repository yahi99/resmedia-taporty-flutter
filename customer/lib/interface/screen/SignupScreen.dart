import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _userBloc = $Provider.of<UserBloc>();
  final FirebaseSignUpBloc _submitBloc = FirebaseSignUpBloc.init(controller: $Provider.of<UserBloc>());

  StreamSubscription registrationLevelSub;
  StreamController privacyStream;
  bool privacy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
      final user = await _userBloc.outFirebaseUser.first;
      if (user != null) Database().createUserGoogle(uid: user.uid, nominative: user.displayName, email: user.email);
      Navigator.pop(context);
    };
  }

  @override
  void dispose() {
    registrationLevelSub?.cancel();
    FirebaseSignUpBloc.close();
    privacyStream.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    privacy = false;
    privacyStream = new StreamController<bool>.broadcast();
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
          top: FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              Icons.lock_outline,
              color: Colors.white,
            ),
          ),
          children: [
            Form(
              key: _submitBloc.formKey,
              child: Column(
                children: <Widget>[
                  // TODO: Aggiungere il nominativo dell'utente
                  EmailField(
                    checker: _submitBloc.emailChecker,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  PasswordField(
                    checker: _submitBloc.passwordChecker,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  PasswordField(
                    checker: _submitBloc.repeatPasswordChecker,
                    decoration: PASSWORD_REPEAT_DECORATION,
                    isLast: true,
                  ),
                  SizedBox(
                    height: 12.0,
                  ),
                  Row(
                    children: <Widget>[
                      StreamBuilder(
                        stream: privacyStream.stream,
                        builder: (ctx, snap) {
                          return Checkbox(
                            value: (snap.hasData) ? snap.data : privacy,
                            onChanged: (value) {
                              privacy = value;
                              privacyStream.add(value);
                            },
                          );
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
                  StreamBuilder(
                    stream: privacyStream.stream,
                    builder: (ctx, snap) {
                      if (snap.hasData) {
                        return SubmitButton.raised(
                          controller: _submitBloc.submitController,
                          child: FittedText('Registrati'),
                        );
                      } else
                        return RaisedButton(
                          child: Text('Registrati'),
                          onPressed: null,
                        );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
