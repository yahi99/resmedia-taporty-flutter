import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:mobile_app/data/config.dart';
import 'package:mobile_app/interface/view/logo_view.dart';
import 'package:mobile_app/logic/bloc/OrdersBloc.dart';
import 'package:mobile_app/logic/bloc/RestaurantBloc.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/restaurant/screen/HomeScreen.dart';

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

  //StreamSubscription registrationLevelSub;

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _submitBloc.submitController.solver = (res) async {
      if (!res) return;

      final registrationLevel = await _userBloc.getRegistrationLevel();
      /*if (registrationLevel == RegistrationLevel.LV2)
        await EasyRouter.push(context, SignUpMoreScreen());*/
      if (registrationLevel == RegistrationLevel.COMPLETE) {
        final orderBloc = OrdersBloc.of();
        await orderBloc.setRestaurantStream();
        String user = (await UserBloc.of().outUser.first).model.restaurantId;
        final restaurantBloc = RestaurantBloc.init(idRestaurant: user);
        await EasyRouter.pushAndRemoveAll(
            context, HomeScreen(restBloc: restaurantBloc));
      }
    };
  }

  @override
  void initState() {
    super.initState();
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
            /*SizedBox(
              height: SPACE * 3,
            ),
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
