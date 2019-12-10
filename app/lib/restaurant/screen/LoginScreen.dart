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
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/OrdersBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/RestaurantBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/restaurant/screen/HomeScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool remember=false;

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
  /*
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('here');
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;
        final type=(await _userBloc.outUser.first).model.type;
        String user = (await UserBloc.of().outUser.first).model.restaurantId;
        print(type);
        if(user!=null && type=='restaurant') {
          final orderBloc = OrdersBloc.of();
          await orderBloc.setRestaurantStream();
          final restaurantBloc = RestaurantBloc.init(idRestaurant: user);
          await EasyRouter.pushAndRemoveAll(
              context, HomeScreen(restBloc: restaurantBloc,restId: user,));
        }
    };
  }
   */

  @override
  void initState() {
    rememberStream=new StreamController<bool>.broadcast();
    _read();
    super.initState();
  }

  @override
  void dispose() {
    FirebaseSignInBloc.close();
    //registrationLevelSub?.cancel();
    rememberStream.close();
    super.dispose();
  }


  _showMailDialog(BuildContext context, FirebaseUser user) {
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

  _read()async{
    final prefs=await SharedPreferences.getInstance();
    final key='remember_me';
    final value=prefs.getBool(key);
    print('read: $value');
    remember=value;
    rememberStream.add(value);
  }
  _write(bool value)async{
    final prefs=await SharedPreferences.getInstance();
    final key='remember_me';
    prefs.setBool(key,value);
    remember=value;
    rememberStream.add(value);
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
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (context, userSnapshot) {
        print('here');
        if (userSnapshot.hasData) {
          if (userSnapshot.data == null)
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
                                checkColor: Colors.white,
                                value: (snap.hasData)?snap.data:false,
                                onChanged: (value){
                                  //privacy=value;
                                  _write(value);
                                  //rememberStream.add(value);
                                },
                                //activeColor: Colors.white,
                              );
                            },
                          ),
                          Text('Ricordami',style: TextStyle(color: Colors.white),),
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
                data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
              ),
            );
          return StreamBuilder<UserModel>(
              stream: Database().getUser(userSnapshot.data),
              builder: (ctx, userId) {
                if (userId.hasData) {
                  if (userSnapshot.data.isEmailVerified) {
                    if(userId.data.type=='restaurant'){
                      final orderBloc = OrdersBloc.of();
                      orderBloc.setRestaurantStream(userId.data.restaurantId);
                      final restaurantBloc = RestaurantBloc.init(idRestaurant: userId.data.restaurantId);
                      return HomeScreen(restBloc: restaurantBloc,restId: userId.data.restaurantId,remember: remember,);
                    }
                    else return Material(
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
                                        checkColor: Colors.white,
                                        value: (snap.hasData)?snap.data:false,
                                        onChanged: (value){
                                          //privacy=value;
                                          _write(value);
                                          //rememberStream.add(value);
                                        },
                                        //activeColor: Colors.white,
                                      );
                                    },
                                  ),
                                  Text('Ricordami',style: TextStyle(color: Colors.white),),
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
                              ),
                            ],
                          ),
                        ),
                        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                      ),
                    );
                  }
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
                                      checkColor: Colors.white,
                                      value: (snap.hasData)?snap.data:false,
                                      onChanged: (value){
                                        //privacy=value;
                                        _write(value);
                                        //rememberStream.add(value);
                                      },
                                      //activeColor: Colors.white,
                                    );
                                  },
                                ),
                                Text('Ricordami',style: TextStyle(color: Colors.white),),
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
                            ),
                          ],
                        ),
                      ),
                      data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                    ),
                  );
                }
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
                                    checkColor: Colors.white,
                                    value: (snap.hasData)?snap.data:false,
                                    onChanged: (value){
                                      //privacy=value;
                                      _write(value);
                                      //rememberStream.add(value);
                                    },
                                    //activeColor: Colors.white,
                                  );
                                },
                              ),
                              Text('Ricordami',style: TextStyle(color: Colors.white),),
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
                        ],
                      ),
                    ),
                    data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
                  ),
                );
              });
        }
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
                            checkColor: Colors.white,
                            value: (snap.hasData)?snap.data:false,
                            onChanged: (value){
                              //privacy=value;
                              _write(value);
                              //rememberStream.add(value);
                            },
                            //activeColor: Colors.white,
                          );
                        },
                      ),
                      Text('Ricordami',style: TextStyle(color: Colors.white),),
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
                ],
              ),
            ),
            data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
          ),
        );
      },
    );
  }
}
