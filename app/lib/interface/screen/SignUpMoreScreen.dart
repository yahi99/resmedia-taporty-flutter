import 'dart:async';

import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_route/easy_route.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_flutter/data/config.dart';
import 'package:resmedia_taporty_flutter/interface/screen/RestaurantListScreen.dart';
import 'package:resmedia_taporty_flutter/interface/view/logo_view.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/SignUpMoreBloc.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print('here');
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
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    registrationLevelSub?.cancel();
    SignUpMoreBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
          /*TextField(
            decoration: InputDecoration(
              labelText: 'E-mail',
            ),
            keyboardType: TextInputType.emailAddress,
          ),
          SizedBox(height: SPACE,),
          TextField(
            decoration: InputDecoration(
              labelText: 'Password',
            ),
            obscureText: true,
          ),
          SizedBox(height: SPACE,),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: RaisedButton(
                  onPressed: () {
                    if (Flavor.CLIENT == FlavorBloc.of().flavor)
                      EasyRouter.push(context, GeoLocScreen());
                    EasyRouter.push(context, HomeScreenDriver());
                  },
                  child: Text('Sign up', style: theme.textTheme.button,),
                ),
              ),
              SizedBox(width: SPACE,),
              Expanded(
                child: RaisedButton(
                  color: cls.primary,
                  onPressed: () {
                    if (Flavor.CLIENT == FlavorBloc.of().flavor)
                      EasyRouter.push(context, GeoLocScreen());
                    EasyRouter.push(context, HomeScreenDriver());
                  },
                  child: Text('Login'),
                ),
              ),
            ],
          ),

          SizedBox(height: SPACE*3,),
          RaisedButton.icon(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.facebookF),
            label: Text('Login with Facebook'),
          ),
          RaisedButton(
            color: Colors.white,
            child: Text('Continua senza registrazione',),
            onPressed: () {
              EasyRouter.push(context, GeoLocScreen());
            },
          )*/
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
    /*return WillPopScope(
      onWillPop: () async => false,
      child: Form(
        key: _submitBloc.formKey,
        child: SignBackground(
          automaticallyImplyLeading: false,
          separator: const SizedBox(height: 16,),
          children: <Widget>[
            NominativeField(
              checker: _submitBloc.outNominative,
            ),
            AddressField(
              checker: _submitBloc.outAddress,
            ),
            PhoneNumberField(
              checker: _submitBloc.outPhoneNumber,
            ),
            SubmitButton.raised(
              controller: _submitBloc.submitController,
              child: FittedText("Salva"),
            ),
          ],
        ),
      ),
    );*/
  }
}
