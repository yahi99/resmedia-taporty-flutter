import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/screen/SignUpMoreScreen.dart';
import 'package:mobile_app/interface/view/logo_view.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';

class SignUpScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "SignUpScreen";

  @override
  String get route => ROUTE;

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _userBloc = UserBloc.of();
  final FirebaseSignUpBloc _submitBloc =
      FirebaseSignUpBloc.init(controller: UserBloc.of());

  StreamSubscription registrationLevelSub;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;

      if (await _userBloc.getRegistrationLevel() == RegistrationLevel.LV2)
        await EasyRouter.push(context, SignUpMoreScreen());
    };
  }

  @override
  void dispose() {
    registrationLevelSub?.cancel();
    FirebaseSignUpBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Material(
      child: LogoView(
        top: FittedBox(
          fit: BoxFit.contain,
          child: Icon(
            Icons.lock_outline,
            color: Colors.white,
          ),
        ),
        children: [
          /*TextField(
            decoration: InputDecoration(
              labelText: 'E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: SPACE,),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          SizedBox(height: SPACE,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    if (Flavor.CLIENT == FlavorBloc.of().flavor)
                      EasyRouter.push(context, GeoLocScreen());
                    EasyRouter.push(context, HomeScreenDriver());
                  },
                  child: Text('Sign up', style: theme.textTheme.button,),
                ),
              ),
              SizedBox(width: SPACE,),
              Expanded(
                child: RaisedButton(
                  color: cls.primary,
                  onPressed: () {
                    if (Flavor.CLIENT == FlavorBloc.of().flavor)
                      EasyRouter.push(context, GeoLocScreen());
                    EasyRouter.push(context, HomeScreenDriver());
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),

          SizedBox(height: SPACE*3,),
          RaisedButton.icon(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.facebookF),
            label: Text('Login with Facebook'),
          ),
          RaisedButton(
            color: Colors.white,
            child: Text('Continua senza registrazione',),
            onPressed: () {
              EasyRouter.push(context, GeoLocScreen());
            },
          )*/
          Form(
            key: _submitBloc.formKey,
            child: Column(
              children: <Widget>[
                EmailField(
                  checker: _submitBloc.emailChecker,
                ),
                SizedBox(
                  height: SPACE,
                ),
                PasswordField(
                  checker: _submitBloc.passwordChecker,
                ),
                SizedBox(
                  height: SPACE,
                ),
                PasswordField(
                  checker: _submitBloc.repeatPasswordChecker,
                  decoration: PASSWORD_REPEAT_DECORATION,
                ),
                SizedBox(
                  height: SPACE,
                ),
                SubmitButton.raised(
                  controller: _submitBloc.submitController,
                  child: FittedText('Registrati'),
                ),
                SizedBox(
                  height: SPACE,
                ),
                RaisedButton.icon(
                  onPressed: () {},
                  icon: Icon(FontAwesomeIcons.facebookF),
                  label: Text('Login with Facebook'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
