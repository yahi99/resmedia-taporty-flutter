
// TODO: HA SENSO?

/*import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/bloc/SubmitBloc.dart';
import 'package:easy_firebase/src/checkers/Checker.dart';
import 'package:easy_firebase/src/checkers/EmailChecker.dart';
import 'package:easy_firebase/src/checkers/PasswordChecker.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


enum LoggerMode {
  SignIn, SignUp,
}


abstract class DefaultLoggerBloc<U> extends SubmitBloc<U> {
  final LoggerMode loggerMode;

  final EmailChecker _emailChecker;
  CheckerRule<String, EmailAuthError> get emailChecker => _emailChecker;

  final PasswordChecker _passwordChecker;
  CheckerRule<String, PasswordAuthError> get passwordChecker => _passwordChecker;

  final PasswordChecker _passwordRepeatChecker;
  CheckerRule<String, PasswordAuthError> get passwordRepeatChecker => _passwordRepeatChecker;

  @mustCallSuper
  dispose() {
    super.dispose();
    _emailChecker.close();
    _passwordChecker.close();
    _passwordRepeatChecker.close();
  }

  @mustCallSuper @override
  Future<bool> postValidate() async {
    if (loggerMode == LoggerMode.SignIn || _passwordChecker.value == _passwordRepeatChecker.value) {
      return true;
    }
    _passwordRepeatChecker.addError(PasswordAuthError.NOT_SAME);
    return false;
  }

  DefaultLoggerBloc({
    bool state: true, @required this.loggerMode,
    @required EmailChecker emailChecker,
    @required PasswordChecker passwordChecker, PasswordChecker passwordRepeatChecker,
  }) :
  assert(loggerMode != null),
  assert(loggerMode != LoggerMode.SignIn || passwordRepeatChecker != null),
  assert(emailChecker != null && passwordChecker != null),
  this._emailChecker = emailChecker, this._passwordChecker = passwordChecker,
  this._passwordRepeatChecker = passwordRepeatChecker,
  super(state: state);
}*/
