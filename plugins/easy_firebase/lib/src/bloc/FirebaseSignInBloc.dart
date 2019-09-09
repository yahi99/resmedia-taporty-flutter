import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/Utility.dart';
import 'package:easy_firebase/src/controllers/DefaultSingInController.dart';
import 'package:easy_firebase/src/controllers/FirebaseUserController.dart';
import 'package:easy_firebase/src/generated/Provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:meta/meta.dart';


class FirebaseSignInBloc with MixinDefaultSingInManager<bool> implements Bloc {
  final Hand _hand = Hand();
  final FormHandler _formHandler = FormHandler();

  GlobalKey<FormState> get formKey => _formHandler.formKey;

  @override
  void dispose() {
    _hand.dispose();
    _formHandler.dispose();
    _singInController.close();
  }
  FirebaseUserManager _firebaseUserController;

  DefaultSingInController<bool> _singInController;
  DefaultSignInManager<bool> get signInManager => _singInController;

  @protected
  Future<bool> _submitter() async {
    final res = await secureFirebaseError(() => _firebaseUserController.inSignInWithEmailAndPassword(
        email: _singInController.email, password: _singInController.password,
      ),

      adderEmailError: _singInController.addEmailError,
      adderPasswordError: _singInController.addPasswordError,
    );
    if (!res)
      _singInController.addSubmitEvent(SubmitEvent.WAITING);
    return res;
  }

  FirebaseSignInBloc.instance() {
    _singInController = DefaultSingInController(
      hand: _hand, formHandler: _formHandler,
      onSubmit: _submitter,
    );
  }
  factory FirebaseSignInBloc.of() => $Provider.of<FirebaseSignInBloc>();
  factory FirebaseSignInBloc.init({@required FirebaseUserManager controller}) {
    final bloc = FirebaseSignInBloc.of();
    bloc._firebaseUserController = controller;
    return bloc;
  }
  static void close() => $Provider.dispose<FirebaseSignInBloc>();


}


/*
  ("ERROR_INVALID_CUSTOM_TOKEN", "The custom token format is incorrect. Please check the documentation."));
  ("ERROR_CUSTOM_TOKEN_MISMATCH", "The custom token corresponds to a different audience."));
  ("ERROR_INVALID_CREDENTIAL", "The supplied auth credential is malformed or has expired."));
  ("ERROR_INVALID_EMAIL", "The email address is badly formatted."));
  ("ERROR_WRONG_PASSWORD", "The password is invalid or the user does not have a password."));
  ("ERROR_USER_MISMATCH", "The supplied credentials do not correspond to the previously signed in user."));
  ("ERROR_REQUIRES_RECENT_LOGIN", "This operation is sensitive and requires recent authentication. Log in again before retrying this request."));
  ("ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL", "An account already exists with the same email address but different sign-in credentials. Sign in using a provider associated with this email address."));
  ("ERROR_EMAIL_ALREADY_IN_USE", "The email address is already in use by another account."));
  ("ERROR_CREDENTIAL_ALREADY_IN_USE", "This credential is already associated with a different user account."));
  ("ERROR_USER_DISABLED", "The user account has been disabled by an administrator."));
  ("ERROR_USER_TOKEN_EXPIRED", "The user\'s credential is no longer valid. The user must sign in again."));
  ("ERROR_USER_NOT_FOUND", "There is no user record corresponding to this identifier. The user may have been deleted."));
  ("ERROR_INVALID_USER_TOKEN", "The user\'s credential is no longer valid. The user must sign in again."));
  ("ERROR_OPERATION_NOT_ALLOWED", "This operation is not allowed. You must enable this service in the console."));
  ("ERROR_WEAK_PASSWORD", "The given password is invalid."));

  ("ERROR_INVALID_CUSTOM_TOKEN", "Il formato del token personalizzato non è corretto. Controlla la documentazione."));
  ("ERROR_CUSTOM_TOKEN_MISMATCH", "Il token personalizzato corrisponde a un pubblico diverso."));
  ("ERROR_INVALID_CREDENTIAL", "La credenziale di autenticazione fornita è malformata o è scaduta."));
  ("ERROR_INVALID_EMAIL", "L'indirizzo email è formattato male."));
  ("ERROR_WRONG_PASSWORD", "La password non è valida o l'utente non ha una password."));
  ("ERROR_USER_MISMATCH", "Le credenziali fornite non corrispondono all'utente precedentemente connesso."));
  ("ERROR_REQUIRES_RECENT_LOGIN", "Questa operazione è sensibile e richiede un'autenticazione recente. Effettua nuovamente l'accesso prima di riprovare la richiesta."));
  ("ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL", "Esiste già un account con lo stesso indirizzo email ma credenziali di accesso diverse. Accedi utilizzando un provider associato a questo indirizzo email."));
  ("ERROR_EMAIL_ALREADY_IN_USE", "L'indirizzo email è già utilizzato da un altro account."));
  ("ERROR_CREDENTIAL_ALREADY_IN_USE", "Questa credenziale è già associata a un altro account utente."));
  ("ERROR_USER_DISABLED", "L'account utente è stato disabilitato da un amministratore."));
  ("ERROR_USER_TOKEN_EXPIRED", "Le credenziali dell'utente non sono più valide. L'utente deve accedere nuovamente."));
  ("ERROR_USER_NOT_FOUND", "Non esiste alcun record utente corrispondente a questo identificatore. L'utente potrebbe essere stato eliminato."));
  ("ERROR_INVALID_USER_TOKEN", "Le credenziali dell'utente non sono più valide. L'utente deve eseguire nuovamente l'accesso."));
  ("ERROR_OPERATION_NOT_ALLOWED", "Questa operazione non è consentita. Devi abilitare questo servizio nella console."));
  ("ERROR_WEAK_PASSWORD", "La password specificata non è valida."));
 */