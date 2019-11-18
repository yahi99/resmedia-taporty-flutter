import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
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

class CreateAdminScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "CreateAdminScreen";

  String get route => ROUTE;

  @override
  _AdminScreenState createState() => _AdminScreenState();
}

class _AdminScreenState extends State<CreateAdminScreen> {

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
  void initState(){
    super.initState();
    //usersStream=new StreamController<List<UserModel>>.broadcast();
  }

  _showPaymentDialog(BuildContext context,String nominative,String id) {
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
                "Vuoi veramente dare i permessi a "+nominative,
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
                      Database().givePermission(id);
                      //permits=
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
      body: StreamBuilder<List<UserModel>>(
        stream: UsersBloc.of().outRequests,
        builder: (ctx,snap){
          if(!snap.hasData) return Center(child: CircularProgressIndicator(),);
          return ListView.builder(
              itemBuilder: (ctx,index){
                final user=snap.data.elementAt(index);
                return Row(
                  children: <Widget>[
                    Text(user.nominative),
                    Text(user.email),
                    RaisedButton(
                      child: Text('Dagli i permessi'),
                      onPressed: (){
                        //permits=false;
                        _showPaymentDialog(context,user.nominative,user.id);
                      },
                    )
                  ],
                );
              }
          );
        },
      ),
    );
  }
}
