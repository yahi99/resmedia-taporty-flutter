import 'dart:async';
import 'dart:io';

import 'package:dash/dash.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:tuple/tuple.dart';

class DriverBloc implements Bloc {
  final DatabaseService _db = DatabaseService();
  final StorageService _storage = StorageService();
  final AuthService _auth = AuthService();
  final CloudMessagingService _messaging = CloudMessagingService();

  @protected
  dispose() {
    _firebaseUserController.close();
    _driverController?.close();
    _refreshTokenSub.cancel();
  }

  BehaviorSubject<FirebaseUser> _firebaseUserController;

  Stream<FirebaseUser> get outFirebaseUser => _firebaseUserController.stream;
  FirebaseUser get firebaseUser => _firebaseUserController.value;

  BehaviorSubject<DriverModel> _driverController;

  Stream<DriverModel> get outDriver => _driverController.stream;

  StreamSubscription _refreshTokenSub;

  DriverBloc.instance() {
    _clearFirebaseUser();
    _firebaseUserController = BehaviorSubject();

    _driverController = BehaviorController.catchStream(source: _firebaseUserController.switchMap((_firebaseUser) {
      if (_firebaseUser == null) return Stream.value(null);
      return _db.getDriverStream(_firebaseUser);
    }));

    // Quando il token cambia, aggiorna nel database
    _refreshTokenSub = CombineLatestStream.combine2(outDriver, _messaging.onTokenRefresh, (driver, fcmToken) => Tuple2<DriverModel, String>(driver, fcmToken)).listen((tuple) async {
      var driver = tuple.item1;
      var fcmToken = tuple.item2;
      if (driver.fcmToken != fcmToken) await _db.updateDriverFcmToken(driver.id, fcmToken);
    });
  }

  // Se un utente era rimasto loggato da una precedente esecuzione dell'app, sloggalo
  Future _clearFirebaseUser() async {
    await signOut();
  }

  Future<bool> _isDriver(FirebaseUser user) async {
    // Controlla che l'utente sia un fattorino
    var idToken = await user.getIdToken(refresh: true);
    return idToken.claims['driver'] == true;
  }

  Future signInWithEmailAndPassword(String email, String password) async {
    var authResult = await _auth.signInWithEmailAndPassword(email, password);
    if (!(await _isDriver(authResult.user))) {
      await signOut();
      throw NotADriverException("user is not a driver");
    }

    _firebaseUserController.value = authResult.user;
  }

  Future<bool> isStripeActivated() async {
    // Controlla se l'utente ha già attivato l'account stripe
    var idToken = await _firebaseUserController.value.getIdToken(refresh: true);
    return idToken.claims['stripeActivated'] == true;
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
