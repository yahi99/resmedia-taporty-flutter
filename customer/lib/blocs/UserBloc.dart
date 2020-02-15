import 'dart:async';
import 'dart:io';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc implements Bloc {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();
  final SharedPreferenceService _sharedPreferenceService = SharedPreferenceService();

  @protected
  dispose() {
    _firebaseUserController.close();
    _userController?.close();
    _authProviderIdController.close();
    _checkProviderIdExists.cancel();
  }

  BehaviorSubject<FirebaseUser> _firebaseUserController;

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;

  BehaviorSubject<UserModel> _userController;

  Stream<UserModel> get outUser => _userController.stream;
  UserModel get user => _userController.value;

  BehaviorSubject<String> _authProviderIdController;
  String get authProviderId => _authProviderIdController.value;
  Stream<String> get outAuthProviderId => _authProviderIdController.stream;

  StreamSubscription _checkProviderIdExists;

  UserBloc.instance() {
    _firebaseUserController = BehaviorSubject();
    _authProviderIdController = BehaviorSubject();
    _userController = BehaviorController.catchStream(source: _firebaseUserController.switchMap((_firebaseUser) {
      if (_firebaseUser == null) return Stream.value(null);
      return _db.getUserStream(_firebaseUser);
    }));

    _initFirebaseUser();
  }

  /* 
    Inserisce come primo valore l'ultimo utente che ha eseguito l'accesso, se esiste.
    Si assicura inoltre che sia presente un provider id.
    Se nessun provider id è salvato nelle SharedPreferences, ne sceglie uno di default tra quelli disponibili
  */
  Future _initFirebaseUser() async {
    var firebaseUser = await _auth.getCurrentUser();

    if (!(await _isCustomer(firebaseUser))) {
      await signOut();
      return;
    }

    _firebaseUserController.value = firebaseUser;

    var providerId = await _sharedPreferenceService.getAuthProvider();
    if (providerId == "") {
      if (firebaseUser.providerData.any((provider) => provider.providerId == GoogleAuthProvider.providerId))
        providerId = GoogleAuthProvider.providerId;
      else if (firebaseUser.providerData.any((provider) => provider.providerId == FacebookAuthProvider.providerId))
        providerId = FacebookAuthProvider.providerId;
      else
        providerId = EmailAuthProvider.providerId;
    }

    await _setProviderId(providerId);
  }

  Future<bool> _isCustomer(FirebaseUser user) async {
    // Controlla che l'utente non sia un admin, un fornitore o un fattorino
    var idToken = await user.getIdToken(refresh: true);
    return idToken.claims['admin'] != true && idToken.claims['supplierAdmin'] != true && idToken.claims['driver'] != true;
  }

  Future _setProviderId(String providerId) async {
    _authProviderIdController.value = providerId;
    await _sharedPreferenceService.setAuthProvider(providerId);
  }

  Future<bool> signInWithGoogle() async {
    var authResult = await _auth.signInWithGoogle();
    if (authResult == null) return false;

    if (!(await _isCustomer(authResult.user))) {
      await signOut();
      throw NotACustomerException("user is not a customer");
    }

    var user = await _db.getUserById(authResult.user.uid);
    if (user == null) {
      await signOut();
      throw NotRegisteredException("user account doesn't exist");
    }

    await _setProviderId(GoogleAuthProvider.providerId);
    _firebaseUserController.value = authResult.user;

    return true;
  }

  Future<bool> signUpWithGoogle() async {
    var authResult = await _auth.signInWithGoogle();
    if (authResult == null) return false;

    await _db.createUser(authResult.user.uid, authResult.user.displayName, authResult.user.email);

    await _setProviderId(GoogleAuthProvider.providerId);
    _firebaseUserController.value = authResult.user;

    return true;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email, password);
    if (!(await _isCustomer(authResult.user))) {
      await signOut();
      throw NotACustomerException("user is not a customer");
    }

    await _setProviderId(EmailAuthProvider.providerId);
    _firebaseUserController.value = authResult.user;
  }

  Future createUserWithEmailAndPassword(String nominative, String email, String password) async {
    var authResult = await _auth.createUserWithEmailAndPassword(email, password);
    await _db.createUser(authResult.user.uid, nominative, email);

    await _setProviderId(EmailAuthProvider.providerId);
    _firebaseUserController.value = authResult.user;
  }

  Future updateProfileImage(File image) async {
    var user = await outUser.first;
    if (user.imageUrl != null && user.imageUrl != "") await _storage.deleteFile(user.imageUrl);
    var imageUrl = await _storage.uploadFile("users/${user.id}", image);
    await _db.updateProfileImage(user.id, imageUrl);
  }

  Future updatePassword(String oldPassword, String password) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticateWithEmailAndPassword(firebaseUser, oldPassword);
    await firebaseUser.updatePassword(password);
  }

  Future updateUserInfo(String oldPassword, String nominative, String email, String phoneNumber) async {
    var firebaseUser = await outFirebaseUser.first;

    if (authProviderId == FacebookAuthProvider.providerId)
      await _auth.reauthenticateWithEmailAndPassword(firebaseUser, oldPassword);
    else if (authProviderId == GoogleAuthProvider.providerId) await _auth.reauthenticateWithGoogle(firebaseUser);

    await firebaseUser.updateEmail(email);
    await _db.updateUserNominative(firebaseUser.uid, nominative);
    await _db.updateUserEmail(firebaseUser.uid, email);
    await _db.updateUserPhoneNumber(firebaseUser.uid, phoneNumber);
  }

  void updateNotifyApp(bool value) async {
    await _db.updateNotifyApp(user.id, value);
  }

  Future signOut() async {
    await _auth.signOut();
    await _setProviderId(null);
    _firebaseUserController.value = null;
  }
}
