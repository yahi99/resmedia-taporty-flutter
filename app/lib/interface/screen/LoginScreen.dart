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
import 'package:resmedia_taporty_flutter/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/RestaurantListScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SignUpMoreScreen.dart';
import 'package:resmedia_taporty_flutter/interface/screen/SignUpScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:toast/toast.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';


import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginHelper {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      debugPrint("Login di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nel login.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      debugPrint("Registrazione di $email eseguito con successo.");

      return result;
    } catch (exception) {
      debugPrint("Errore nella registrazione.");
      debugPrint(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser firebaseUser =
        (await firebaseAuth.signInWithCredential(authCredential));
    debugPrint("Eseguito l'accesso con Google di ${firebaseUser.email}.");
    Database().putUser(firebaseUser);

    return firebaseUser;
  }

  static Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    debugPrint("Eseguito il logout.");
  }

  Future<void> requestNewPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}

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
        final cls = theme.colorScheme;
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

  _showMailDialog(BuildContext context) {
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
                        onPressed: ()async {
                          final user=await _userBloc.outFirebaseUser.first;
                          user.sendEmailVerification();
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
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
      bool isAnonymous = (await _userBloc.outFirebaseUser.first).isAnonymous;
      bool isAnon = (isAnonymous != null) ? isAnonymous : false;
      if (isAnon) {
        if ((await PermissionHandler()
                .checkPermissionStatus(PermissionGroup.location)) !=
            PermissionStatus.granted)
          _showPositionDialog(context, true);
        else
          Geolocator()
              .getCurrentPosition()
              .then(
                (position) async => await EasyRouter.pushAndRemoveAll(
                  context,
                  RestaurantListScreen(
                    isAnonymous: isAnon,
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
        final registrationLevel = await _userBloc.getRegistrationLevel();
        final user=await _userBloc.outFirebaseUser.first;
        if (registrationLevel == RegistrationLevel.LV2)
          await EasyRouter.push(context, SignUpMoreScreen());
        if (registrationLevel == RegistrationLevel.COMPLETE) {
          if (user.isEmailVerified) {
            if ((await PermissionHandler()
                .checkPermissionStatus(PermissionGroup.location)) !=
                PermissionStatus.granted)
              _showPositionDialog(context, false);
            else
              Geolocator()
                  .getCurrentPosition()
                  .then(
                    (position) async =>
                await EasyRouter.pushAndRemoveAll(
                  context,
                  RestaurantListScreen(
                    isAnonymous: isAnon,
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
          }
          else{
            //Toast.show('Devi confermare il tuo account per accedere', context);
            _showMailDialog(context);
          }
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

  void _showDialog(BuildContext context) {
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

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
        if (userSnapshot.hasData) {
          if (userSnapshot.data is bool)
            return Material(
              child:Theme(
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
                        LoginHelper().signInWithGoogle();
                      },
                      icon: Icon(FontAwesomeIcons.facebookF),
                      label: Text('Login with Facebook'),
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
                data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
              ),
            );

          Geolocator()
              .getCurrentPosition()
              .then(
                (position) async => await EasyRouter.pushAndRemoveAll(
                  context,
                  RestaurantListScreen(
                    isAnonymous: userSnapshot.data.isAnonymous,
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
        }

        return Container(
          child: Center(
            child: CircularProgressIndicator(),
          ),
          color: Colors.white,
          width: double.infinity,
          height: double.infinity,
        );
      },
    );
  }
}
