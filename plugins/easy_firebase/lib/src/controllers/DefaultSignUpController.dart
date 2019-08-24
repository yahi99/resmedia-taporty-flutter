import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/material.dart';

class DefaultSignUpController<V> implements Controller, DefaultSignUpManager<V> {

  void close() {}

  final EmailChecker _emailChecker;
  CheckerRule get emailChecker => _emailChecker;
  String get email => _emailChecker.value;
  void addEmailError(EmailAuthError error) => _emailChecker.addError(error);

  final PasswordChecker _passwordChecker;
  CheckerRule get passwordChecker => _passwordChecker;
  String get password => _passwordChecker.value;

  final PasswordChecker _repeatPasswordChecker;
  CheckerRule get repeatPasswordChecker => _repeatPasswordChecker;
  void addRepeatPasswordError(PasswordAuthError error) => _repeatPasswordChecker.addError(error);

  final CacheSubject<bool> _rememberMeController = CacheSubject.seeded(false);
  Stream<bool> get outRememberMe => _rememberMeController.stream;

  final SubmitController<V> submitController;
  void addSubmitEvent(SubmitEvent event) => submitController.addEvent(event);
  set solver(ValueChanged<V> solver) => submitController.solver = solver;

  Future<void> inRememberMe(bool isRememberMe) async => _rememberMeController.add(isRememberMe);

  Future<bool> _postValidate() async {
    if (_passwordChecker.value != _repeatPasswordChecker.value) {
      _repeatPasswordChecker.addError(PasswordAuthError.NOT_SAME);
      return false;
    }
    return true;
  }

  DefaultSignUpController({
    @required Hand hand, @required FormHandler formHandler,
    @required Submitter<V> onSubmit,
  }) : this._emailChecker = EmailChecker(hand: hand),
    _passwordChecker = PasswordChecker(hand: hand),
    _repeatPasswordChecker = PasswordChecker(hand: hand),
    submitController = SubmitController<V>(onSubmit: onSubmit, handler: formHandler, hand: hand) {
    formHandler.addPostValidator(_postValidate);
  }
}


abstract class DefaultSignUpManager<V> {
  CheckerRule get emailChecker;

  CheckerRule get passwordChecker;

  CheckerRule get repeatPasswordChecker;

  SubmitController<V> get submitController;
}


mixin MixinDefaultSingUpManager<V> implements DefaultSignUpManager<V> {
  DefaultSignUpManager<V> get signUpManager;

  CheckerRule get emailChecker => signUpManager.emailChecker;

  CheckerRule get passwordChecker => signUpManager.passwordChecker;

  CheckerRule get repeatPasswordChecker => signUpManager.repeatPasswordChecker;

  SubmitController<V> get submitController => signUpManager.submitController;
}