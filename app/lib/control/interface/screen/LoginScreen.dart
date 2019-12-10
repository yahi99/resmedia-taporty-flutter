import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/control/interface/screen/HomeScreenPanel.dart';
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

class LoginScreen extends StatefulWidget implements WidgetRoute {
  static const String ROUTE = "LoginScreen";

  String get route => ROUTE;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  //static final FacebookLogin facebookSignIn = FacebookLogin();

  //my code
  //final FirebaseAuth _fAuth = FirebaseAuth.instance;
  //end my code

  final FirebaseSignInBloc _submitBloc =
  FirebaseSignInBloc.init(controller: UserBloc.of());
  final _userBloc = UserBloc.of();

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
    /*_submitBloc.submitController.solver = (res) async {
      if (!res) return;
      //final user=(await _userBloc.outUser.first);
      //if(user.model.isDriver!=null && user.model.isDriver) {
      final registrationLevel = await _userBloc.getRegistrationLevel();
      final type=(await _userBloc.outUser.first).model.type;
      /*if (registrationLevel == RegistrationLevel.LV2)
        await EasyRouter.push(context, SignUpMoreScreen());*/
      if (type=='control' || type=='admin') {
        await OrdersBloc.of().setCtrlStream();
        await EasyRouter.pushAndRemoveAll(context, HomeScreenPanel());
      }
      else {
        //if(user!=null) _userBloc.logout();
        Toast.show('Utente non abilitato', context);
      }
    };

     */
    //else{
    // if(user!=null) _userBloc.logout();
    //   Toast.show('Utente non abilitato', context,duration: 3);
    //  }
    //};
  }

  @override
  void dispose() {
    FirebaseSignInBloc.close();
    //registrationLevelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cls = theme.colorScheme;
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx,userSnapshot){
        if (userSnapshot.hasData) {
          if (userSnapshot.data == null)
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
                  ],
                ),
              ),
            );
          print(userSnapshot.data.uid);
          return StreamBuilder<UserModel>(
              stream: Database().getUser(userSnapshot.data),
              builder: (ctx, userId) {
                if (userId.hasData && (userId.data.type=='control' || userId.data.type=='admin')) {
                  OrdersBloc.of().setCtrlStream();
                  return HomeScreenPanel();
                }
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
                      ],
                    ),
                  ),
                );
              });
        }
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
              ],
            ),
          ),
        );
      },
    );
  }
}
