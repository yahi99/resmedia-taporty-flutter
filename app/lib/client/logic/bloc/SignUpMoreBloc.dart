import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:flutter/cupertino.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class SignUpMoreBloc implements Bloc {
  final Database _db = Database();

  final Hand _hand = Hand();
  final FormHandler _formHandler = FormHandler();

  GlobalKey<FormState> get formKey => _formHandler.formKey;

  @override
  void dispose() {
    _hand.dispose();
    _formHandler.dispose();
  }

  AddressChecker _addressChecker;

  CheckerRule get outAddress => _addressChecker;

  NominativeChecker _nominativeChecker;

  CheckerRule get outNominative => _nominativeChecker;

  PhoneNumberChecker _phoneNumberChecker;

  CheckerRule get outPhoneNumber => _phoneNumberChecker;

  SubmitController _submitController;

  SubmitController get submitController => _submitController;

  Future<bool> _signer() async {
    final userBloc = UserBloc.of();
    print("BLOC");
    userBloc.outFirebaseUser.listen(print);
    final firebaseUser = await userBloc.outFirebaseUser.first;
    print("FAKE");
    print(firebaseUser);
    await userBloc.nextRegistrationLv(_db.createUser(
      uid: firebaseUser.uid,
      model: UserModel(
        nominative: _nominativeChecker.data.value,
        email: firebaseUser.email,
        phoneNumber: _phoneNumberChecker.data.value.toString(),
      ),
    ));

    return true;
  }

  SignUpMoreBloc.instance() : super() {
    _nominativeChecker = NominativeChecker(hand: _hand);
    _addressChecker = AddressChecker(hand: _hand);
    _phoneNumberChecker = PhoneNumberChecker(hand: _hand);
    _submitController = SubmitController(onSubmit: _signer, handler: _formHandler, hand: _hand);
  }

  factory SignUpMoreBloc.of() => $Provider.of<SignUpMoreBloc>();

  static void close() => $Provider.dispose<SignUpMoreBloc>();
}
