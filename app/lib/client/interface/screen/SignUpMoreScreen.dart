import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/RestaurantListScreen.dart';
import 'package:resmedia_taporty_flutter/common/interface/view/LogoView.dart';
import 'package:resmedia_taporty_flutter/client/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';

class SignUpMoreScreen extends StatefulWidget implements WidgetRoute {
  static const ROUTE = "SignUpMoreScreen";

  String get route => ROUTE;

  const SignUpMoreScreen({Key key}) : super(key: key);

  @override
  _SignUpMoreScreenState createState() => _SignUpMoreScreenState();
}

class _SignUpMoreScreenState extends State<SignUpMoreScreen> {
  final _userBloc = UserBloc.of();
  final SignUpMoreBloc _submitBloc = SignUpMoreBloc.of();

  StreamSubscription registrationLevelSub;

  bool isVerified;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    /*print('here');
    registrationLevelSub?.cancel();
    _submitBloc.submitController.solver = (res) async {
      print('maybe here');
      if (!res) return;
      final user= (await UserBloc.of().outUser.first);
      print(user);
      print('not here');
      if(user!=null)print(user.model);
      if(user!=null && user.model!=null)print(user.model);
      if (await _userBloc.getRegistrationLevel() == RegistrationLevel.COMPLETE && user!=null && user.model!=null && user.model.type=='user'){
        await EasyRouter.pushAndRemoveAll(context, RestaurantListScreen());
      }
      else EasyRouter.pop(context);
    };

     */
  }

  @override
  void dispose() {
    registrationLevelSub?.cancel();
    SignUpMoreBloc.close();
    super.dispose();
  }

  _showMailDialog(BuildContext context) {
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
                          final user = await _userBloc.outFirebaseUser.first;
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

  getUser() async {
    FirebaseUser currentUser = await FirebaseAuth.instance.currentUser();

    if (currentUser == null)
      return true;
    else
      return currentUser;
  }

  @override
  void initState(){
    super.initState();
    isVerified=false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getUser(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> userSnapshot) {
        if (userSnapshot.hasData) {
          if (userSnapshot.data is bool)
            return Material(
              child: LogoView(
                top: FittedBox(
                  fit: BoxFit.contain,
                  child: Icon(
                    Icons.lock_outline,
                    color: Colors.white,
                  ),
                ),
                children: [
                  Form(
                    key: _submitBloc.formKey,
                    child: Column(
                      children: <Widget>[
                        NominativeField(
                          checker: _submitBloc.outNominative,
                        ),
                        SizedBox(
                          height: SPACE,
                        ),
                        AddressField(
                          checker: _submitBloc.outAddress,
                        ),
                        SizedBox(
                          height: SPACE,
                        ),
                        PhoneNumberField(
                          checker: _submitBloc.outPhoneNumber,
                        ),
                        SizedBox(
                          height: SPACE,
                        ),
                        SubmitButton.raised(
                          controller: _submitBloc.submitController,
                          child: FittedText("Salva"),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          if (!isVerified) {
            isVerified=true;
            Geolocator().getCurrentPosition().then((position) async {
              final user = await _userBloc.outFirebaseUser.first;
              if (user.isEmailVerified)
                await EasyRouter.pushAndRemoveAll(
                  context,
                  RestaurantListScreen(
                    isAnonymous: userSnapshot.data.isAnonymous,
                    position: position,
                    user: (await _userBloc.outUser.first).model,
                  ),
                );
              else
                _showMailDialog(context);
            }).catchError(
                  (error) {
                if (error is PlatformException) {
                  print(error.code);
                }
              },
            );
          }
        }
        return Material(
          child: LogoView(
            top: FittedBox(
              fit: BoxFit.contain,
              child: Icon(
                Icons.lock_outline,
                color: Colors.white,
              ),
            ),
            children: [
              Form(
                key: _submitBloc.formKey,
                child: Column(
                  children: <Widget>[
                    NominativeField(
                      checker: _submitBloc.outNominative,
                    ),
                    SizedBox(
                      height: SPACE,
                    ),
                    AddressField(
                      checker: _submitBloc.outAddress,
                    ),
                    SizedBox(
                      height: SPACE,
                    ),
                    PhoneNumberField(
                      checker: _submitBloc.outPhoneNumber,
                    ),
                    SizedBox(
                      height: SPACE,
                    ),
                    SubmitButton.raised(
                      controller: _submitBloc.submitController,
                      child: FittedText("Salva"),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
