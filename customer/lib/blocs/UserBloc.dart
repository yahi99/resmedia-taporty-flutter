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
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @protected
  dispose() {
    _firebaseUserController.close();
    _userController?.close();
  }

  BehaviorSubject<FirebaseUser> _firebaseUserController;

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;

  BehaviorSubject<UserModel> _userController;

  Stream<UserModel> get outUser => _userController.stream;
  UserModel get user => _userController.value;

  UserBloc.instance() {
    _firebaseUserController = BehaviorController.catchStream(source: _firebaseAuth.onAuthStateChanged.asyncMap((_firebaseUser) {
      if (_firebaseUser == null) return null;
      return _isCustomer(_firebaseUser).then((isCustomer) {
        if (isCustomer) return _firebaseUser;
        return null;
      });
    }));

    _userController = BehaviorController.catchStream(source: _firebaseUserController.switchMap((_firebaseUser) {
      if (_firebaseUser == null) return Stream.value(null);
      return _db.getUserStream(_firebaseUser);
    }));
  }

  Future<bool> _isCustomer(FirebaseUser user) async {
    // Controlla che l'utente non sia un admin, un fornitore o un fattorino
    var idToken = await user.getIdToken(refresh: true);
    return idToken.claims['admin'] != true && idToken.claims['supplierAdmin'] != true && idToken.claims['driver'] != true;
  }

  Future<bool> signInWithGoogle() async {
    var authResult = await _auth.signInWithGoogle();
    if (authResult == null) return false;

    if (!(await _isCustomer(authResult.user))) {
      await _auth.signOut();
      throw NotACustomerException("user is not a customer");
    }

    var user = await _db.getUserById(authResult.user.uid);
    if (user == null) {
      await _auth.signOut();
      throw NotRegisteredException("user account doesn't exist");
    }

    return true;
  }

  Future<bool> signUpWithGoogle() async {
    var authResult = await _auth.signInWithGoogle();
    if (authResult == null) return false;

    await _db.createUser(authResult.user.uid, authResult.user.displayName, authResult.user.email);
    return true;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email, password);
    if (!(await _isCustomer(authResult.user))) {
      await _auth.signOut();
      throw NotACustomerException("user is not a customer");
    }
  }

  Future createUserWithEmailAndPassword(String nominative, String email, String password) async {
    var authResult = await _auth.createUserWithEmailAndPassword(email, password);
    await _db.createUser(authResult.user.uid, nominative, email);
  }

  Future updateProfileImage(File image) async {
    var user = await outUser.first;
    if (user.imageUrl != null && user.imageUrl != "") await _storage.deleteFile(user.imageUrl);
    var imageUrl = await _storage.uploadFile("users/${user.id}", image);
    await _db.updateProfileImage(user.id, imageUrl);
  }

  Future updatePassword(String oldPassword, String password) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticate(firebaseUser, oldPassword);
    await firebaseUser.updatePassword(password);
  }

  Future updateUserInfo(String oldPassword, String nominative, String email, String phoneNumber) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticate(firebaseUser, oldPassword);
    await firebaseUser.updateEmail(email);
    await _db.updateUserNominative(firebaseUser.uid, nominative);
    await _db.updateUserEmail(firebaseUser.uid, email);
    await _db.updateUserPhoneNumber(firebaseUser.uid, phoneNumber);
  }

  /*void updateNotifyEmail(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateNotifyEmail').call({'uid': restUser.uid, 'notifyEmail': value});
  }

  void updateOffersSms(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateOffersSms').call({'uid': restUser.uid, 'offersSms': value});
  }

  void updateNotifySms(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateNotifySms').call({'uid': restUser.uid, 'notifySms': value});
  }*/

  void updateNotifyApp(bool value) async {
    await _db.updateNotifyApp(user.id, value);
  }

  /*void updateOffersEmail(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateOffersEmail').call({'uid': restUser.uid, 'offersEmail': value});
  }

  void updateOffersApp(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateOffersApp').call({'uid': restUser.uid, 'offersApp': value});
  }*/
}
