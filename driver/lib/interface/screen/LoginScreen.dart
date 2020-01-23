import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/blocs/UserBloc.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseSignInBloc _submitBloc = FirebaseSignInBloc.init(controller: $Provider.of<UserBloc>());

  Future<void> setDriver(String uid) async {
    final userBloc = $Provider.of<UserBloc>();
    final orderBloc = $Provider.of<OrderBloc>();
    await orderBloc.setDriverStream((await userBloc.outFirebaseUser.first).uid);
    final driverBloc = $Provider.of<DriverBloc>();
    await driverBloc.setDriverStream((await userBloc.outFirebaseUser.first).uid);
  }

  @override
  void dispose() {
    FirebaseSignInBloc.close();
    //registrationLevelSub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<FirebaseUser>(
      stream: FirebaseAuth.instance.onAuthStateChanged,
      builder: (ctx, userSnapshot) {
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
                      height: 12.0,
                    ),
                    PasswordField(
                      checker: _submitBloc.passwordChecker,
                    ),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: SubmitButton.raised(
                            controller: _submitBloc.submitController,
                            child: FittedText('Accedi'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          return StreamBuilder<UserModel>(
            stream: Database().getUser(userSnapshot.data),
            builder: (ctx, userId) {
              if (userId.hasData && userId.data.type == 'driver') {
                setDriver(userId.data.id);
                Navigator.popAndPushNamed(context, "/home");
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
                        height: 12.0,
                      ),
                      PasswordField(
                        checker: _submitBloc.passwordChecker,
                      ),
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: SubmitButton.raised(
                              controller: _submitBloc.submitController,
                              child: FittedText('Accedi'),
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
                  height: 12.0,
                ),
                PasswordField(
                  checker: _submitBloc.passwordChecker,
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: SubmitButton.raised(
                        controller: _submitBloc.submitController,
                        child: FittedText('Accedi'),
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
