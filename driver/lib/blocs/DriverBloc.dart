import 'dart:async';
import 'dart:io';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class NotADriverException implements Exception {
  final String message;
  const NotADriverException(this.message);
}

class NotRegisteredException implements Exception {
  final String message;
  const NotRegisteredException(this.message);
}

class DriverBloc implements Bloc {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  @protected
  dispose() {
    _firebaseUserController.close();
    _driverController?.close();
  }

  BehaviorSubject<FirebaseUser> _firebaseUserController = BehaviorSubject();

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;

  BehaviorSubject<DriverModel> _driverController = BehaviorSubject();

  Stream<DriverModel> get outDriver => _driverController.stream;

  StreamSubscription<DriverModel> _driverControllerSub;

  DriverBloc.instance() {
    _firebaseAuth.onAuthStateChanged.listen((_firebaseUser) async {
      if (_firebaseUser == null)
        _firebaseUserController.add(null);
      else {
        if (!(await _isDriver(_firebaseUser))) {
          _firebaseUserController.add(null);
        } else {
          _firebaseUserController.add(_firebaseUser);
          await _driverControllerSub?.cancel();
          _driverControllerSub = _db.getDriverStream(_firebaseUser).listen((user) => _driverController.add(user));
        }
      }
    });
  }

  Future<bool> _isDriver(FirebaseUser user) async {
    // Controlla che l'utente sia un fattorino
    var idToken = await user.getIdToken(refresh: true);
    return !!idToken.claims['driver'];
  }

  Future<AuthResult> signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email, password);
    if (!(await _isDriver(authResult.user))) {
      await _auth.signOut();
      throw NotADriverException("user is not a driver");
    }

    return authResult;
  }

  Future updateProfileImage(File image) async {
    var user = await outDriver.first;
    if (user.imageUrl != null && user.imageUrl != "") await _storage.deleteFile(user.imageUrl);
    var imageUrl = await _storage.uploadFile("users/${user.id}", image);
    await _db.updateDriverProfileImage(user.id, imageUrl);
  }

  Future updatePassword(String oldPassword, String password) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticate(firebaseUser, oldPassword);
    await firebaseUser.updatePassword(password);
  }

  Future updateNominativeAndEmail(String oldPassword, String nominative, String email) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticate(firebaseUser, oldPassword);
    await firebaseUser.updateEmail(email);
    await _db.updateDriverNominative(firebaseUser.uid, nominative);
    await _db.updateDriverEmail(firebaseUser.uid, email);
  }
}
