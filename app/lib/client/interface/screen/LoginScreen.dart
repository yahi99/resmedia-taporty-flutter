import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/GeolocalizationScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/SupplierListScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/SignUpScreen.dart';
import 'package:resmedia_taporty_flutter/common/interface/view/LogoView.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
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

  final FirebaseSignInBloc _submitBloc = FirebaseSignInBloc.init(controller: UserBloc.of());
  final _userBloc = UserBloc.of();

  StreamSubscription registrationLevelSub;

  // TODO: Utilizza
  _showPositionDialog(BuildContext context, bool isAnon) {
    showDialog(
      context: context,
      builder: (_context) {
        final theme = Theme.of(context);
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 12.0 * 2,
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
                        onPressed: () async {
                          try {
                            var position = await Geolocator().getCurrentPosition();
                            var customerCoordinates = GeoPoint(position.latitude, position.longitude);
                            var customerAddress = (await Geocoder.local.findAddressesFromCoordinates(Coordinates(position.latitude, position.longitude))).first.addressLine;
                            await EasyRouter.pushAndRemoveAll(
                              context,
                              SupplierListScreen(isAnonymous: isAnon, customerCoordinates: customerCoordinates, customerAddress: customerAddress, user: (await _userBloc.outUser.first).model),
                            );
                          } catch (e) {}
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
          content: Wrap(
            alignment: WrapAlignment.center,
            runSpacing: 12.0 * 2,
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
    return StreamBuilder(
      stream: PermissionHandler().checkPermissionStatus(PermissionGroup.location).asStream(),
      builder: (ctx, perm) {
        return StreamBuilder<FirebaseUser>(
          stream: FirebaseAuth.instance.onAuthStateChanged,
          builder: (context, userSnapshot) {
            print('here');
            if (userSnapshot.hasData) {
              if (userSnapshot.data == null) return _buildLoginForm();
              return StreamBuilder<UserModel>(
                stream: Database().getUser(userSnapshot.data),
                builder: (ctx, userId) {
                  if (userId.hasData && (userId.data.type == null || userId.data.type == 'user')) {
                    if (userSnapshot.data.isEmailVerified) {
                      return GeoLocScreen();
                    }
                    return _buildLoginForm(showConfirmEmail: true, user: userSnapshot.data);
                  }
                  return _buildLoginForm();
                },
              );
            }

            return _buildLoginForm();
          },
        );
      },
    );
  }

  _buildLoginForm({showConfirmEmail = false, user}) {
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
                height: 12.0,
              ),
              PasswordField(
                checker: _submitBloc.passwordChecker,
              ),
              if (showConfirmEmail)
                SizedBox(
                  height: 12.0,
                ),
              if (showConfirmEmail)
                RaisedButton.icon(
                  onPressed: () {
                    _showMailDialog(context, user);
                  },
                  icon: Icon(Icons.mail),
                  label: Text('Conferma e-mail'),
                ),
              if (showConfirmEmail)
                SizedBox(
                  height: 12.0,
                ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () {
                        EasyRouter.push(context, SignUpScreen());
                      },
                      child: FittedText('Registrati'),
                    ),
                  ),
                  SizedBox(
                    width: 12.0,
                  ),
                  Expanded(
                    child: SubmitButton.raised(
                      controller: _submitBloc.submitController,
                      child: FittedText('Accedi'),
                    ),
                  ),
                ],
              ),
              /*SizedBox(
                height: 12.0 * 3,
              ),
              RaisedButton.icon(
                onPressed: () {
                  _submitBloc.submitterGoogle();
                },
                icon: Icon(FontAwesomeIcons.google),
                label: Text('Login con Google'),
              ),*/
            ],
          ),
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
