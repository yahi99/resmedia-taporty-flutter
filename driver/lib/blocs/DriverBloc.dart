import 'dart:async';
import 'dart:io';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class DriverBloc implements Bloc {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();

  @protected
  dispose() {
    _firebaseUserController.close();
    _driverController?.close();
  }

  BehaviorSubject<FirebaseUser> _firebaseUserController;

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;

  BehaviorSubject<DriverModel> _driverController;

  Stream<DriverModel> get outDriver => _driverController.stream;

  DriverBloc.instance() {
    _clearFirebaseUser();
    _firebaseUserController = BehaviorSubject();

    _driverController = BehaviorController.catchStream(source: _firebaseUserController.switchMap((_firebaseUser) {
      if (_firebaseUser == null) return Stream.value(null);
      return _db.getDriverStream(_firebaseUser);
    }));
  }

  // Se un utente era rimasto loggato da una precedente esecuzione dell'app, sloggalo
  Future _clearFirebaseUser() async {
    await signOut();
  }

  Future<bool> _isDriver(FirebaseUser user) async {
    // Controlla che l'utente sia un fattorino
    var idToken = await user.getIdToken(refresh: true);
    return !!idToken.claims['driver'];
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email, password);
    if (!(await _isDriver(authResult.user))) {
      await signOut();
      throw NotADriverException("user is not a driver");
    }

    _firebaseUserController.value = authResult.user;
  }

  Future updateProfileImage(File image) async {
    var user = await outDriver.first;
    if (user.imageUrl != null && user.imageUrl != "") await _storage.deleteFile(user.imageUrl);
    var imageUrl = await _storage.uploadFile("users/${user.id}", image);
    await _db.updateDriverProfileImage(user.id, imageUrl);
  }

  Future updatePassword(String oldPassword, String password) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticateWithEmailAndPassword(firebaseUser, oldPassword);
    await firebaseUser.updatePassword(password);
  }

  Future updateNominativeAndEmail(String oldPassword, String nominative, String email) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticateWithEmailAndPassword(firebaseUser, oldPassword);
    await firebaseUser.updateEmail(email);
    await _db.updateDriverNominative(firebaseUser.uid, nominative);
    await _db.updateDriverEmail(firebaseUser.uid, email);
  }

  Future signOut() async {
    await _auth.signOut();
    _firebaseUserController.value = null;
  }
}
