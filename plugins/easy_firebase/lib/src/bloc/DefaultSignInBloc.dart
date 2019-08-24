
/*import 'package:easy_firebase/src/bloc/SubmitBloc.dart';
import 'package:easy_firebase/src/checkers/Checker.dart';
import 'package:easy_firebase/src/checkers/EmailChecker.dart';
import 'package:easy_firebase/src/checkers/PasswordChecker.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


@deprecated
abstract class DefaultSignInBloc<U> extends SubmitBloc<U> {
  final EmailChecker _emailChecker;
  CheckerRule<EmailAuthError> get emailChecker => _emailChecker;

  final PasswordChecker _passwordChecker;
  CheckerRule<PasswordAuthError> get passwordChecker => _passwordChecker;

  @mustCallSuper
  dispose() {
    super.dispose();
    _emailChecker.close();
    _passwordChecker.close();
  }

  DefaultSignInBloc({
    bool state: true,
    @required EmailChecker emailChecker, @required PasswordChecker passwordChecker,
  }) :
    assert(emailChecker != null && passwordChecker != null),
    this._emailChecker = emailChecker, this._passwordChecker = passwordChecker,
    super(state: state);
}*/
