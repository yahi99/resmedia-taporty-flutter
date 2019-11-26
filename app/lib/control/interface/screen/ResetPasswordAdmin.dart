import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/ControlBloc.dart';
import 'package:resmedia_taporty_flutter/control/logic/bloc/UsersBloc.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/drivers/interface/screen/HomeScreen.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/CalendarBloc.dart';
import 'package:resmedia_taporty_flutter/drivers/logic/bloc/TurnBloc.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:toast/toast.dart';

//import 'package:flutter_facebook_login/flutter_facebook_login.dart';
//import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordAdmin extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "CreateAdminScreen";

  final String userId;

  ResetPasswordAdmin({@required this.userId});

  String get route => ROUTE;

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<ResetPasswordAdmin> {
  //bool permits=false;

  //static final FacebookLogin facebookSignIn = FacebookLogin();

  //my code
  //final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  //StreamController usersStream;

  //final FirebaseSignInBloc _submitBloc =
  //FirebaseSignInBloc.init(controller: UserBloc.of());
  //final _userBloc = UserBloc.of();

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
  void dispose() {
    //FirebaseSignInBloc.close();
    //registrationLevelSub?.cancel();
    //usersStream.close();
    super.dispose();
    //FirebaseAuth.instance.createUserWithEmailAndPassword(email: null, password: null);
  }

  @override
  void initState() {
    super.initState();
    //usersStream=new StreamController<List<UserModel>>.broadcast();
  }

  _showPaymentDialog(BuildContext context, String nominative, String mail) {
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
                "Vuoi veramente resettare la password a " + nominative + ' ?',
                style: theme.textTheme.body2,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                //crossAxisAlignment:CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      EasyRouter.pop(context);
                    },
                    textColor: Colors.white,
                    color: Colors.red,
                    child: Text(
                      "Nega",
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      //Database().givePermission(id);
                      //permits=
                      FirebaseAuth.instance
                          .sendPasswordResetEmail(email: mail)
                          .catchError((error) {
                        if (error is PlatformException) {
                          if (error.code == 'ERROR_INVALID_EMAIL') {
                            Toast.show('Email non valida', context);
                          }
                          if (error.code == 'ERROR_USER_NOT_FOUND') {
                            Toast.show(
                                'Email non corrisponde ad un utente', context);
                          }
                        }
                      }).then((value) {
                        Toast.show('Reset e-mail inviata', context);
                      });
                      EasyRouter.pop(context);
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
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text('Recupero Password'),
      ),
      body: StreamBuilder<List<UserModel>>(
        stream: ControlBloc.instance().outRequests,
        builder: (ctx, snap) {
          if (!snap.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          if (snap.data.length > 0)
            return ListView.separated(
              itemCount: snap.data.length,
              itemBuilder: (ctx, index) {
                final user = snap.data.elementAt(index);
                if (user.id != widget.userId)
                  return Row(
                    children: <Widget>[
                      Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              child: Text(
                                user.nominative,
                                style: theme.textTheme.subtitle,
                              ),
                              padding: EdgeInsets.all(4.0),
                            ),
                            Padding(
                              child: Text(user.email),
                              padding: EdgeInsets.all(4.0),
                            ),
                          ],
                        ),
                        width: MediaQuery.of(context).size.width * 2 / 3,
                      ),
                      Expanded(
                        child: Padding(
                          child: RaisedButton(
                            child: Text('Reset'),
                            onPressed: () {
                              //permits=false;
                              _showPaymentDialog(
                                  context, user.nominative, user.email);
                            },
                          ),
                          padding: EdgeInsets.only(right: 4.0),
                        ),
                      ),
                    ],
                  );
                return Container();
              },
              separatorBuilder: (ctx, index) {
                return Divider(
                  height: 8.0,
                );
              },
            );
          return Padding(
            child: Text('Non ci sono utenti amministratore'),
            padding: EdgeInsets.all(8.0),
          );
        },
      ),
    );
  }
}
