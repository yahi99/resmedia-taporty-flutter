import 'dart:async';
import 'dart:io';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class NotACustomerException implements Exception {
  final String message;
  const NotACustomerException(this.message);
}

class NotRegisteredException implements Exception {
  final String message;
  const NotRegisteredException(this.message);
}

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

  BehaviorSubject<FirebaseUser> _firebaseUserController = BehaviorSubject();

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;

  BehaviorSubject<UserModel> _userController = BehaviorSubject();

  Stream<UserModel> get outUser => _userController.stream;

  StreamSubscription<UserModel> _userControllerSub;

  UserBloc.instance() {
    _firebaseAuth.onAuthStateChanged.listen((_firebaseUser) async {
      if (_firebaseUser == null)
        _firebaseUserController.add(null);
      else {
        if (!(await _isCustomer(_firebaseUser))) {
          _firebaseUserController.add(null);
        } else {
          _firebaseUserController.add(_firebaseUser);
          await _userControllerSub?.cancel();
          _userControllerSub = _db.getUserStream(_firebaseUser).listen((user) => _userController.add(user));
        }
      }
    });
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

  Future updateNominativeAndEmail(String oldPassword, String nominative, String email) async {
    var firebaseUser = await outFirebaseUser.first;
    await _auth.reauthenticate(firebaseUser, oldPassword);
    await firebaseUser.updateEmail(email);
    await _db.updateNominative(firebaseUser.uid, nominative);
    await _db.updateEmail(firebaseUser.uid, email);
  }

  void updateNotifyEmail(bool value) async {
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
  }

  void updateNotifyApp(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateNotifyApp').call({'uid': restUser.uid, 'notifyApp': value});
  }

  void updateOffersEmail(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateOffersEmail').call({'uid': restUser.uid, 'offersEmail': value});
  }

  void updateOffersApp(bool value) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateOffersApp').call({'uid': restUser.uid, 'offersApp': value});
  }

  // TODO: Elimina
  Future<double> getDistance(LatLng start, LatLng end) async {
    return (await Geolocator().distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude));
  }

  // TODO: Elimina
  Future<double> getMockDistance() async {
    return 3.0;
  }
}
