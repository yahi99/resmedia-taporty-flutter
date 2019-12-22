import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantListScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/SignUpScreen.dart';
import 'package:resmedia_taporty_flutter/common/interface/view/LogoView.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

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

  bool isVerified;
  var permission;
  var pos;

  //static final FacebookLogin facebookSignIn = FacebookLogin();

  //my code
  //final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  final FirebaseSignInBloc _submitBloc =
      FirebaseSignInBloc.init(controller: UserBloc.of());
  final _userBloc = UserBloc.of();

  StreamSubscription registrationLevelSub;

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

  _showPositionDialog(BuildContext context, bool isAnon) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Column(
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
                        textColor: Colors.white,
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
                        textColor: Colors.white,
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

  _showMailDialog(BuildContext context, FirebaseUser user) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: SPACE * 2,
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    "Account non confermato, clicca qui sotto per mandare la mail di conferma.",
                    style: theme.textTheme.body2,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //crossAxisAlignment:CrossAxisAlignment.stretch,
                    children: <Widget>[
                      RaisedButton(
                        onPressed: () async {
                          user.sendEmailVerification();
                          UserBloc.of().logout();
                          LoginHelper().signOut();
                          EasyRouter.pop(context);
                        },
                        color: Colors.blue,
                        textColor: Colors.white,
                        child: Text(
                          "Invia",
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
    /*print('changed');
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
      print('not here');
      final registrationLevel = await _userBloc.getRegistrationLevel();
      final user = await _userBloc.outFirebaseUser.first;
      //print(user.uid);
      Database().getUser(user).first.then((userId) async {
        print(userId.type);
        //final user = await _userBloc.outFirebaseUser.first;
        print('here');
        if (registrationLevel == RegistrationLevel.COMPLETE &&
            (userId.type == 'user' || userId.type == null)) {
          print('not here');
          if (user.isEmailVerified) {
            if ((await PermissionHandler()
                    .checkPermissionStatus(PermissionGroup.location)) !=
                PermissionStatus.granted)
              _showPositionDialog(context, false);
            else
              Geolocator()
                  .getCurrentPosition()
                  .then(
                    (position) async => await EasyRouter.pushAndRemoveAll(
                      context,
                      RestaurantListScreen(
                        position: position,
                        user: (await _userBloc.outUser.first).model,
                      ),
                    ),
                  )
                  .catchError(
                (error) {
                  if (error is PlatformException) {
                    print(error.code);
                  }
                },
              );
          } else {
            //Toast.show('Devi confermare il tuo account per accedere', context);
            _showMailDialog(context);
          }
        } else {
          Toast.show('Utente non abilitato', context);
        }
      });
      if (registrationLevel == RegistrationLevel.LV2)
        await EasyRouter.push(context, SignUpMoreScreen());
    };

     */
  }

  //TODO: Sistemare login automatico e senza registrazione
  @override
  void initState() {
    getPos();
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
    isVerified = false;
    super.initState();
  }

  void _showDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(20))),
            content: Scaffold(
              body: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  AutoSizeText(
                      'Per poter diventare un fattorino/ristoratore è necessario registrarsi.'),
                  AutoSizeText(
                      'Una volta registrato effettua il login e in alto alla pagina principale troverai un\'icona per entrare nelle impostazioni del tuo account'),
                  Padding(
                    child: Image.asset('assets/img/account.jpg'),
                    padding: EdgeInsets.only(top: SPACE, bottom: SPACE),
                  ),
                  AutoSizeText(
                      'Quando sei entrato nelle impostazioni c\'è una lista di possibili azioni, seleziona Diventa un fattorino/ristoratore'),
                  Padding(
                    child: Image.asset('assets/img/upgrade.jpg'),
                    padding: EdgeInsets.only(top: SPACE, bottom: SPACE),
                  ),
                  AutoSizeText(
                      'Compila i campi richiesti ed una volta inviata la richiesta verrà presa in visione nel minor tempo possibile e verrai notificato se la richiesta è andata a buon fine'),
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
  void dispose() {
    FirebaseSignInBloc.close();
    registrationLevelSub?.cancel();
    super.dispose();
  }

  getUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser == null)
      return true;
    else
      return currentUser;
  }

  getPos() async {
    if (permission == PermissionStatus.granted)
      pos = await Geolocator().getCurrentPosition();
    print(pos);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: PermissionHandler()
            .checkPermissionStatus(PermissionGroup.location)
            .asStream(),
        builder: (ctx, perm) {
          return StreamBuilder<FirebaseUser>(
            stream: FirebaseAuth.instance.onAuthStateChanged,
            builder: (context, userSnapshot) {
              print('here');
              if (userSnapshot.hasData) {
                if (userSnapshot.data == null)
                  return Material(
                    child: Theme(
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
                                _submitBloc.submitterGoogle();
                              },
                              icon: Icon(FontAwesomeIcons.google),
                              label: Text('Login with Google'),
                            ),
                            /*
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
                    */
                            RaisedButton(
                              color: Colors.white,
                              child: Container(
                                width: double.infinity,
                                child: Center(
                                  child: AutoSizeText(
                                    "Diventa un fattorino/ristoratore",
                                    maxLines: 1,
                                    minFontSize: 6.0,
                                  ),
                                ),
                              ),
                              onPressed: () {
                                _showDialog(context);
                              },
                            ),
                          ],
                        ),
                      ),
                      data: Theme.of(context)
                          .copyWith(unselectedWidgetColor: Colors.white),
                    ),
                  );
                return StreamBuilder<UserModel>(
                    stream: Database().getUser(userSnapshot.data),
                    builder: (ctx, userId) {
                      if (userId.hasData &&
                          (userId.data.type == null ||
                              userId.data.type == 'user')) {
                        if (userSnapshot.data.isEmailVerified) {
                          if (pos != null)
                            return RestaurantListScreen(
                              isAnonymous: userSnapshot.data.isAnonymous,
                              position: pos,
                              user: userId.data,
                            );
                          return GeoLocScreen();
                        }
                        return Material(
                          child: Theme(
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
                                  SizedBox(
                                    height: SPACE,
                                  ),
                                  RaisedButton.icon(
                                    onPressed: () {
                                      _showMailDialog(
                                          context, userSnapshot.data);
                                    },
                                    icon: Icon(Icons.mail),
                                    label: Text('Conferma e-mail'),
                                  ),
                                  SizedBox(
                                    height: SPACE,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Expanded(
                                        child: RaisedButton(
                                          onPressed: () {
                                            EasyRouter.push(
                                                context, SignUpScreen());
                                          },
                                          child: FittedText('Sign up'),
                                        ),
                                      ),
                                      SizedBox(
                                        width: SPACE,
                                      ),
                                      Expanded(
                                        child: SubmitButton.raised(
                                          controller:
                                              _submitBloc.submitController,
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
                                      _submitBloc.submitterGoogle();
                                    },
                                    icon: Icon(FontAwesomeIcons.google),
                                    label: Text('Login with Google'),
                                  ),
                                  /*
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
                    */
                                  RaisedButton(
                                    color: Colors.white,
                                    child: Container(
                                      width: double.infinity,
                                      child: Center(
                                        child: AutoSizeText(
                                          "Diventa un fattorino/ristoratore",
                                          maxLines: 1,
                                          minFontSize: 6.0,
                                        ),
                                      ),
                                    ),
                                    onPressed: () {
                                      _showDialog(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                            data: Theme.of(context)
                                .copyWith(unselectedWidgetColor: Colors.white),
                          ),
                        );
                      }
                      return Material(
                        child: Theme(
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
                                          EasyRouter.push(
                                              context, SignUpScreen());
                                        },
                                        child: FittedText('Sign up'),
                                      ),
                                    ),
                                    SizedBox(
                                      width: SPACE,
                                    ),
                                    Expanded(
                                      child: SubmitButton.raised(
                                        controller:
                                            _submitBloc.submitController,
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
                                    _submitBloc.submitterGoogle();
                                  },
                                  icon: Icon(FontAwesomeIcons.google),
                                  label: Text('Login with Google'),
                                ),
                                RaisedButton(
                                  color: Colors.white,
                                  child: Container(
                                    width: double.infinity,
                                    child: Center(
                                      child: AutoSizeText(
                                        "Diventa un fattorino/ristoratore",
                                        maxLines: 1,
                                        minFontSize: 6.0,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    _showDialog(context);
                                  },
                                ),
                              ],
                            ),
                          ),
                          data: Theme.of(context)
                              .copyWith(unselectedWidgetColor: Colors.white),
                        ),
                      );
                    });
              }
              return Material(
                child: Theme(
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
                            _submitBloc.submitterGoogle();
                          },
                          icon: Icon(FontAwesomeIcons.google),
                          label: Text('Login with Google'),
                        ),
                        /*
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
                    */
                        RaisedButton(
                          color: Colors.white,
                          child: Container(
                            width: double.infinity,
                            child: Center(
                              child: AutoSizeText(
                                "Diventa un fattorino/ristoratore",
                                maxLines: 1,
                                minFontSize: 6.0,
                              ),
                            ),
                          ),
                          onPressed: () {
                            _showDialog(context);
                          },
                        ),
                      ],
                    ),
                  ),
                  data: Theme.of(context)
                      .copyWith(unselectedWidgetColor: Colors.white),
                ),
              );
            },
          );
        });
  }
}
