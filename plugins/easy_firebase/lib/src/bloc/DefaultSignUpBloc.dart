/*import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/bloc/SubmitBloc.dart';
import 'package:easy_firebase/src/checkers/Checker.dart';
import 'package:easy_firebase/src/checkers/EmailChecker.dart';
import 'package:easy_firebase/src/checkers/PasswordChecker.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';



abstract class DefaultSignUpBloc<U> extends SubmitBloc<U> {
  final EmailChecker _emailChecker;
  CheckerRule<EmailAuthError> get emailChecker => _emailChecker;

  final PasswordChecker _passwordChecker;
  CheckerRule<PasswordAuthError> get passwordChecker => _passwordChecker;

  final PasswordChecker _passwordRepeatChecker;
  CheckerRule<PasswordAuthError> get passwordRepeatChecker => _passwordRepeatChecker;

  @mustCallSuper
  dispose() {
    super.dispose();
    _emailChecker.close();
    _passwordChecker.close();
    _passwordRepeatChecker.close();
  }

  @mustCallSuper @override
  Future<bool> postValidate() async {
    if (_passwordChecker.value == _passwordRepeatChecker.value) {
      return true;
    }
    _passwordRepeatChecker.addError(PasswordAuthError.NOT_SAME);
    return false;
  }

  DefaultSignUpBloc({
    bool state: true,
    @required EmailChecker emailChecker,
    @required PasswordChecker passwordChecker, @required PasswordChecker passwordRepeatChecker,
  }) :
  assert(emailChecker != null && passwordChecker != null),
  this._emailChecker = emailChecker, this._passwordChecker = passwordChecker,
  this._passwordRepeatChecker = passwordRepeatChecker,
  super(state: state);
}*/
