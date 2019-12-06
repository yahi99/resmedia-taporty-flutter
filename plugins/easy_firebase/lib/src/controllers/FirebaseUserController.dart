import 'dart:async';

import 'package:easy_firebase/src/Utility.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';
import 'package:meta/meta.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';


class FirebaseUserController<L> implements FirebaseUserManager<L> {
  final FirebaseAuth _fba;

  void close() {
    _firebaseUserController.close();
  }

  FirebaseUser _firebaseUser;
  BehaviorSubject<FirebaseUser> _firebaseUserController;
  Observable<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream.where((_) => !_isInLoading);

  Completer<L> _registrationLevel = Completer();
  Completer<L> get registrationLevel => _registrationLevel;
  Future<L> getRegistrationLevel() => _registrationLevel.future;
  bool _isInLoading = true;
  bool get isInLoading => _isInLoading;

  Future<FirebaseUser> inSignInWithCredential({@required AuthCredential credential}) async {
    assert(credential != null);
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await _fba.signInWithCredential(credential));
    return _firebaseUser;
  }

  Future<FirebaseUser> inSignInWithEmailAndPassword({@required String email, @required String password}) async {
    assert(email != null && password != null);
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await _fba.signInWithEmailAndPassword(
      email: email, password: password,
    ));
    return _firebaseUser;
  }

  Future<FirebaseUser> inSignUpWithEmailAndPassword({@required String email, @required String password}) async {
    assert(email != null && password != null);
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await _fba.createUserWithEmailAndPassword(
      email: email, password: password,
    ));
    return _firebaseUser;
  }

  Future<FirebaseUser> inSignInWithGoogle() async {
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await LoginHelper().signInWithGoogle());
    return _firebaseUser;
  }

  Future<FirebaseUser> inSignInAnonymously() async {
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await _fba.signInAnonymously());
    return _firebaseUser;
  }

  Future<FirebaseUser> inSignInWithCostumToken(@required String token) async {
    assert(token!=null);
    _registrationLevel = Completer();
    _firebaseUserHandler = await converterFirebaseError<FirebaseUser>(() async => await _fba.signInWithCustomToken(token: token));
    return _firebaseUser;
  }

  Future<LV> nextRegistrationLv<LV>(Future<LV> conveyor) async {
    _registrationLevel = Completer();
    return await conveyor;
  }

  Future<void> _loadToken() async {
    _firebaseUserHandler = await _fba.currentUser();
    _isInLoading = false;
  }

  Future<void> logout() async {
    await _fba.signOut();
    _firebaseUserHandler = null;
    _registrationLevel = Completer();
  }

  set _firebaseUserHandler(FirebaseUser value) => _firebaseUserController.add(_firebaseUser = value);

  FirebaseUserController({
    FirebaseAuth firebaseAuth,
  }) : this._fba = firebaseAuth??FirebaseAuth.instance {
    _firebaseUserController = BehaviorSubject();
    _loadToken();
  }
}


abstract class FirebaseUserManager<L> {
  Observable<FirebaseUser> get outFirebaseUser;

  Future<L> getRegistrationLevel();

  Future<FirebaseUser> inSignInWithCredential({@required AuthCredential credential});

  Future<FirebaseUser> inSignInAnonymously();

  Future<FirebaseUser> inSignInWithCostumToken(@required String token);

  Future<FirebaseUser> inSignInWithEmailAndPassword({@required String email, @required String password});

  Future<FirebaseUser> inSignUpWithEmailAndPassword({@required String email, @required String password});

  Future<FirebaseUser> inSignInWithGoogle();

  Future<LV> nextRegistrationLv<LV>(Future<LV> conveyor);

  Future<void> logout();
}


mixin MixinFirebaseUserManager<L> implements FirebaseUserManager{
  FirebaseUserManager<L> get firebaseUserManager;

  Observable<FirebaseUser> get outFirebaseUser => firebaseUserManager.outFirebaseUser;

  Future<L> getRegistrationLevel() => firebaseUserManager.getRegistrationLevel();

  Future<FirebaseUser> inSignInWithCredential({@required AuthCredential credential}) {
    return firebaseUserManager.inSignInWithCredential(credential: credential);
  }

  Future<FirebaseUser> inSignInAnonymously() {
    return firebaseUserManager.inSignInAnonymously();
  }
  Future<FirebaseUser> inSignInWithCostumToken(@required String token) {
    return firebaseUserManager.inSignInWithCostumToken(token);
  }

  Future<FirebaseUser> inSignInWithEmailAndPassword({@required String email, @required String password}) {
    return firebaseUserManager.inSignInWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> inSignUpWithEmailAndPassword({@required String email, @required String password}) {
    return firebaseUserManager.inSignUpWithEmailAndPassword(email: email, password: password);
  }

  Future<FirebaseUser> inSignInWithGoogle() {
    return firebaseUserManager.inSignInWithGoogle();
  }

  Future<LV> nextRegistrationLv<LV>(Future<LV> conveyor) {
    return firebaseUserManager.nextRegistrationLv(conveyor);
  }

  Future<void> logout() => firebaseUserManager.logout();
}

class LoginHelper {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);

      print("Login di $email eseguito con successo.");

      return result;
    } catch (exception) {
      print("Errore nel login.");
      print(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> createUserWithEmailAndPassword(
      String email, String password) async {
    try {
      FirebaseUser result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      print("Registrazione di $email eseguito con successo.");

      return result;
    } catch (exception) {
      print("Errore nella registrazione.");
      print(exception.toString());

      return null;
    }
  }

  Future<FirebaseUser> signInWithGoogle() async {
    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount == null) return null;

    final GoogleSignInAuthentication googleSignInAuthentication =
    await googleSignInAccount.authentication;

    final AuthCredential authCredential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final FirebaseUser firebaseUser =
    (await firebaseAuth.signInWithCredential(authCredential));
    print("Eseguito l'accesso con Google di ${firebaseUser.email}.");
    //Database().putUser(firebaseUser);
    Database().getUser(firebaseUser).first.then((userId) async {
      if(userId==null){
        await Database().createUserGoogle(uid: firebaseUser.uid, nominative: firebaseUser.displayName,email:firebaseUser.email);
      }
    }
    );
    return firebaseUser;
  }

  Future<void> signOut() async {
    await googleSignIn.signOut();
    //await FirebaseAuth.instance.signOut();
    print("Eseguito il logout.");
  }

  Future<void> requestNewPassword(String email) async {
    await firebaseAuth.sendPasswordResetEmail(email: email);
  }
}