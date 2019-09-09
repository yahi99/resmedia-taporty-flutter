import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/RestaurantListScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SignUpMoreScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SignUpScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:toast/toast.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "LoginScreen";

  String get route => ROUTE;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  static const ROUTE = "LoginScreen";

  String get route => ROUTE;

  //static final FacebookLogin facebookSignIn = new FacebookLogin();

  //my code
  //final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  final FirebaseSignInBloc _submitBloc =
      FirebaseSignInBloc.init(controller: UserBloc.of());
  final _userBloc = UserBloc.of();

  StreamSubscription registrationLevelSub;

  /*void _signIn(BuildContext context) async {
    var facebookLogin=new FacebookLogin();
    var result= await facebookLogin.logInWithReadPermissions(['email','public_profile']);
    FirebaseUser firebaseUser;
    switch(result.status){
      case FacebookLoginStatus.loggedIn:
        FacebookAccessToken myToken = result.accessToken;
        AuthCredential credential =
        FacebookAuthProvider.getCredential(accessToken: myToken.token);
        firebaseUser =
        await FirebaseAuth.instance.signInWithCredential(credential);
        print('Done');
        print(firebaseUser.toString());
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Cancelled by user');
        break;
      case FacebookLoginStatus.error:
        print('Error');
        break;
    }
  }*/

  _showPositionDialog(BuildContext context, bool isAnon) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              new Column(
                children: <Widget>[
                  Text(
                    "Utilizza posizione corrente?",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () {
                          EasyRouter.pushAndRemoveAll(
                            context,
                            GeoLocScreen(isAnonymous: isAnon),
                          );
                        },
                        textColor: Colors.black,
                        color: Colors.red,
                        child: Text(
                          "Nega",
                        ),
                      ),
                      RaisedButton(
                        onPressed: () {
                          Geolocator()
                              .getCurrentPosition()
                              .then((position) async {
                            print(position.toString());
                            await EasyRouter.pushAndRemoveAll(
                              context,
                              RestaurantListScreen(
                                  isAnonymous: isAnon,
                                  position: position,
                                  user: (await _userBloc.outUser.first).model),
                            );
                          }).catchError(
                            (error) {
                              if (error is PlatformException) {
                                print(error.code);
                              }
                            },
                          );
                        },
                        color: Colors.green,
                        textColor: Colors.black,
                        child: Text(
                          "Consenti",
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
      bool isAnonymous = (await _userBloc.outFirebaseUser.first).isAnonymous;
      bool isAnon = (isAnonymous != null) ? isAnonymous : false;
      if (isAnon)
        _showPositionDialog(context, true);
      else {
        final registrationLevel = await _userBloc.getRegistrationLevel();
        if (registrationLevel == RegistrationLevel.LV2)
          await EasyRouter.push(context, SignUpMoreScreen());
        if (registrationLevel == RegistrationLevel.COMPLETE) {
          _showPositionDialog(context, false);
        }
      }
    };
  }

  //TODO: Sistemare login automatico e senza registrazione
  @override
  void initState() {
    /*final FirebaseAuth _fAuth = FirebaseAuth.instance;
    _fAuth.currentUser().then((user) {
      if (user != null) {
        _userBloc.outUser.first.then((user) {
          if (user.userFb.isAnonymous)
            _showPositionDialog(context, true);
          else
            _showPositionDialog(context, false);
        });
        /*user.getIdToken().then((token){
          _userBloc.inSignInWithCostumToken(token).then((user){
            _userBloc.outUser.first.then((user){
              if(user.userFb.isAnonymous) _showPositionDialog(context,true);
              else _showPositionDialog(context,false);
            });
          });
        });*/
      }
    });*/
    super.initState();
  }

  @override
  void dispose() {
    FirebaseSignInBloc.close();
    registrationLevelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Form(
        key: _submitBloc.formKey,
        child: LogoView(
          top: FittedBox(
            fit: BoxFit.contain,
            child: Icon(
              Icons.lock_outline,
              color: Colors.white,
            ),
          ),
          children: [
            EmailField(
              checker: _submitBloc.emailChecker,
            ),
            SizedBox(
              height: SPACE,
            ),
            PasswordField(
              checker: _submitBloc.passwordChecker,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      EasyRouter.push(context, SignUpScreen());
                    },
                    child: FittedText('Sign up'),
                  ),
                ),
                SizedBox(
                  width: SPACE,
                ),
                Expanded(
                  child: SubmitButton.raised(
                    controller: _submitBloc.submitController,
                    child: FittedText('Login'),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SPACE * 3,
            ),
            RaisedButton.icon(
              onPressed: () {
                Toast.show('Disponibile in futuro', context,
                    duration: 3, gravity: Toast.BOTTOM);
              },
              icon: Icon(FontAwesomeIcons.facebookF),
              label: Text('Login with Facebook'),
            ),
            RaisedButton(
              color: Colors.white,
              child: Container(
                width: double.infinity,
                child: Center(
                  child: AutoSizeText(
                    "Continua senza registrazione",
                    maxLines: 1,
                    minFontSize: 6.0,
                  ),
                ),
              ),
              onPressed: () {
                Toast.show("Disponibile in futuro", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                //_userBloc.inSignInAnonymously();
              },
            ),
          ],
        ),
      ),
    );
  }
}
