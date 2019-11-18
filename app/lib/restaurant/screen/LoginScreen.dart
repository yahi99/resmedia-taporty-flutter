import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/HomeScreen.dart';
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

  //static final FacebookLogin facebookSignIn = FacebookLogin();

  //my code
  //final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  StreamController rememberStream;

  final FirebaseSignInBloc _submitBloc =
      FirebaseSignInBloc.init(controller: UserBloc.of());
  final _userBloc = UserBloc.of();

  final _mailKey = GlobalKey<FormFieldState>();

  //StreamSubscription registrationLevelSub;

  /*void _signIn(BuildContext context) async {
    var facebookLogin=FacebookLogin();
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;

      final registrationLevel = await _userBloc.getRegistrationLevel();
      /*if (registrationLevel == RegistrationLevel.LV2)
        await EasyRouter.push(context, SignUpMoreScreen());*/
      if (registrationLevel == RegistrationLevel.COMPLETE) {
        final type=(await _userBloc.outUser.first).model.type;
        String user = (await UserBloc.of().outUser.first).model.restaurantId;
        if(user!=null && type=='restaurant') {
          final orderBloc = OrdersBloc.of();
          await orderBloc.setRestaurantStream();
          final restaurantBloc = RestaurantBloc.init(idRestaurant: user);
          await EasyRouter.pushAndRemoveAll(
              context, HomeScreen(restBloc: restaurantBloc,restId: user,));
        }
      }
    };
  }

  @override
  void initState() {
    rememberStream=new StreamController<bool>.broadcast();
    super.initState();
  }

  @override
  void dispose() {
    FirebaseSignInBloc.close();
    //registrationLevelSub?.cancel();
    rememberStream.close();
    super.dispose();
  }

  _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        final cls = theme.colorScheme;
        return AlertDialog(
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Text(
                "Inserisci la mail dell\'account che vuoi resettare!",
                style: theme.textTheme.body2,
              ),
              TextField(
                key: _mailKey,
              ),
              RaisedButton(
                child: Text('Resetta Password'),
                onPressed: (){
                  FirebaseAuth.instance.sendPasswordResetEmail(email: _mailKey.currentState.value).catchError((error){
                    if(error is PlatformException){
                      if(error.code=='ERROR_INVALID_EMAIL'){
                        Toast.show('Email non valida',context);
                      }
                      if(error.code=='ERROR_USER_NOT_FOUND'){
                        Toast.show('Email non corrisponde ad un utente',context);
                      }
                    }
                  }).then((value){
                    Toast.show('Reset e-mail inviata', context);
                  });
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
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
                /*Expanded(
                  child: RaisedButton(
                    onPressed: () {
                      EasyRouter.push(context, SignUpScreen());
                    },
                    child: FittedText('Sign up'),
                  ),
                ),
                SizedBox(
                  width: SPACE,
                ),*/
                Expanded(
                  child: SubmitButton.raised(
                    controller: _submitBloc.submitController,
                    child: FittedText('Login'),
                  ),
                ),
              ],
            ),
            Row(
              children: <Widget>[
                StreamBuilder(
                  stream: rememberStream.stream,
                  builder: (ctx,snap){
                    return Checkbox(
                      value: (snap.hasData)?snap.data:false,
                      onChanged: (value){
                        //privacy=value;
                        rememberStream.add(value);
                      },
                    );
                  },
                ),
                Text('Ricordami'),
              ],
            ),
            SizedBox(
              height: SPACE * 3,
            ),
            RaisedButton(
              child: Text('Reset password'),
              onPressed: (){
                _showResetDialog(context);
              },
            )
            /*
            RaisedButton.icon(
              onPressed: () {},
              icon: Icon(FontAwesomeIcons.facebookF),
              label: Text('Login with Facebook'),
            ),
            RaisedButton(
              color: Colors.white,
              child: Text(
                'Continua senza registrazione',
              ),
              onPressed: () {
                EasyRouter.push(context, GeoLocScreen());
              },
            )*/
          ],
        ),
      ),
    );
  }
}
