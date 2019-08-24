import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/foundation.dart';
import 'package:meta/meta.dart';

class DefaultSingInController<V> implements Controller, DefaultSignInManager<V> {

  @override
  void close() {}

  EmailChecker _emailChecker;
  CheckerRule get emailChecker => _emailChecker;
  String get email => _emailChecker.value;
  void addEmailError(EmailAuthError error) => _emailChecker.addError(error);

  PasswordChecker _passwordChecker;
  CheckerRule get passwordChecker => _passwordChecker;
  String get password => _passwordChecker.value;
  void addPasswordError(PasswordAuthError error) => _passwordChecker.addError(error);

  CacheSubject<bool> _rememberMeController = CacheSubject.seeded(false);
  Stream<bool> get outRememberMe => _rememberMeController.stream;

  SubmitController<V> submitController;
  void addSubmitEvent(SubmitEvent event) => submitController.addEvent(event);
  set solver(ValueChanged<V> solver) => submitController.solver = solver;

  Future<void> inRememberMe(bool isRememberMe) async {
    _rememberMeController.add(isRememberMe);
  }

  DefaultSingInController({
    @required Hand hand, @required FormHandler formHandler,
    @required Submitter<V> onSubmit,
  }) :
    _emailChecker = EmailChecker(hand: hand),
    _passwordChecker = PasswordChecker(hand: hand),
    submitController = SubmitController<V>(handler: formHandler, onSubmit: onSubmit, hand: hand);
}


abstract class DefaultSignInManager<V> {
  CheckerRule get emailChecker;

  CheckerRule get passwordChecker;

  SubmitController<V> get submitController;
}


mixin MixinDefaultSingInManager<V> implements DefaultSignInManager<V> {
  DefaultSignInManager<V> get signInManager;

  CheckerRule get emailChecker => signInManager.emailChecker;

  CheckerRule get passwordChecker => signInManager.passwordChecker;

  SubmitController<V> get submitController => signInManager.submitController;
}