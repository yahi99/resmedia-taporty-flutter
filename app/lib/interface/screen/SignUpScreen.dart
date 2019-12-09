import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SignUpMoreScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';

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
  StreamController privacyStream;
  bool privacy;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
      final user=await _userBloc.outFirebaseUser.first;
      if ( user!= null)
        Database().createUserGoogle(uid: user.uid, nominative: user.displayName, email: user.email);
        EasyRouter.pop(context);
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
  void initState(){
    super.initState();
    privacy=false;
    privacyStream= new StreamController<bool>.broadcast();
  }

  void _showPolicyDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_context) {
          final theme = Theme.of(context);
          final cls = theme.colorScheme;
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Scaffold(
              body: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  AutoSizeText(
                      'Privacy Policy'),
                  RaisedButton(
                    child: Text('  Chiudi  '),
                    onPressed: () => EasyRouter.pop(context),
                  ),
                ],
              ),
            ),
          );
        });
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Material(
        child:Theme(
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
                  isLast: true,
                ),
                SizedBox(
                  height: SPACE,
                ),
                Row(
                  children: <Widget>[
                    StreamBuilder(
                      stream: privacyStream.stream,
                      builder: (ctx,snap){
                        return Checkbox(
                          value: (snap.hasData)?snap.data:privacy,
                          onChanged: (value){
                            privacy=value;
                            privacyStream.add(value);
                          },
                        );
                      },
                    ),
                    FlatButton(
                      child: Text('Privacy Policy',style: TextStyle(color: Colors.white),),
                      onPressed: (){
                        _showPolicyDialog(context);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: SPACE,
                ),
                StreamBuilder(
                  stream: privacyStream.stream,
                  builder: (ctx,snap){
                    if(snap.hasData){
                      return SubmitButton.raised(
                        controller: _submitBloc.submitController,
                        child: FittedText('Registrati'),
                      );
                    }
                    else return RaisedButton(child: Text('Registrati'),onPressed: null,);
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
