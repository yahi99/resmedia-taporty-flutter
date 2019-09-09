

// TODO: HA SENSO?


/*import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/Utility.dart';
import 'package:easy_firebase/src/bloc/DefaultLoggerBloc.dart';
import 'package:easy_firebase/src/checkers/EmailChecker.dart';
import 'package:easy_firebase/src/checkers/PasswordChecker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


abstract class FirebaseLoggerBloc<U> extends DefaultLoggerBloc<U> {
  final EmailChecker _emailChecker;
  final PasswordChecker _passwordChecker;

  FirebaseAuth _auth = FirebaseAuth.instance;

  @mustCallSuper
  init({FirebaseAuth auth}) {
    _auth = auth;
  }

  @protected
  Future<FirebaseUser> signerFirebase() async {
    return secureFirebaseError(() async {
      return loggerMode == LoggerMode.SignIn ?
      await _auth.signInWithEmailAndPassword(
        email: _emailChecker.value, password: _passwordChecker.value,) :
      await _auth.createUserWithEmailAndPassword(
        email: _emailChecker.value, password: _passwordChecker.value,
      );
    }, adderEmailError: _emailChecker.addError, adderPasswordError: _passwordChecker.addError);
  }

  FirebaseLoggerBloc({
    @required LoggerMode loggerMode, @required EmailChecker emailChecker,
    @required PasswordChecker passwordChecker, @required PasswordChecker passwordRepeatChecker,
  }) :
  this._emailChecker = emailChecker,
  this._passwordChecker = passwordChecker,
  super(
    loggerMode: loggerMode, emailChecker: emailChecker,
    passwordChecker: passwordChecker, passwordRepeatChecker: passwordRepeatChecker,
  );
}*/
