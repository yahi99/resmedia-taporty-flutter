import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/Utility.dart';
import 'package:easy_firebase/src/controllers/DefaultSignUpController.dart';
import 'package:easy_firebase/src/controllers/FirebaseUserController.dart';
import 'package:easy_firebase/src/generated/Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:meta/meta.dart';


class FirebaseSignUpBloc with MixinDefaultSingUpManager<bool> implements Bloc {
  final Hand _hand = Hand();
  final FormHandler _formHandler = FormHandler();

  GlobalKey<FormState> get formKey => _formHandler.formKey;

  @override
  dispose() {
    _hand.dispose();
    _formHandler.dispose();
    _signUpController.close();
  }

  FirebaseUserManager _firebaseUserController;
  DefaultSignUpController<bool> _signUpController;
  DefaultSignUpManager<bool> get signUpManager => _signUpController;


  Future<bool> _signer() async {
    final res = await secureFirebaseError(() async =>
      await _firebaseUserController.inSignUpWithEmailAndPassword(
        email: _signUpController.email,
        password: _signUpController.password,
      ),
      adderEmailError: _signUpController.addEmailError,
      adderPasswordError: _signUpController.addRepeatPasswordError,
    );
    if (!res)
      _signUpController.addSubmitEvent(SubmitEvent.WAITING);
    return res;
  }

  FirebaseSignUpBloc.instance() : super() {
    _signUpController = DefaultSignUpController(
      hand: _hand, formHandler: _formHandler,
      onSubmit: _signer,
    );
  }

  factory FirebaseSignUpBloc.of() => $Provider.of<FirebaseSignUpBloc>();
  factory FirebaseSignUpBloc.init({@required FirebaseUserManager controller}) {
    final bloc = FirebaseSignUpBloc.of();
    bloc._firebaseUserController = controller;
    return bloc;
  }
  static void close() => $Provider.dispose<FirebaseSignUpBloc>();


}