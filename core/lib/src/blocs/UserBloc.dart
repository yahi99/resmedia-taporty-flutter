import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/src/config/StripeConfig.dart';
import 'package:resmedia_taporty_core/src/models/ReviewModel.dart';
import 'package:resmedia_taporty_core/src/models/UserModel.dart';
import 'package:rxdart/rxdart.dart';

import 'package:resmedia_taporty_core/src/resources/Database.dart';

class UserBloc with MixinFirebaseUserManager implements Bloc {
  final Database _db = Database();

  @protected
  dispose() {
    if (_userReviewController != null) _userReviewController.close();
    _userController?.close();
    _notificationController?.close();
  }

  final FirebaseUserController _firebaseUserController = FirebaseUserController();

  FirebaseUserManager get firebaseUserManager => _firebaseUserController;

  BehaviorSubject<List<ReviewModel>> _userReviewController;

  Stream<List<ReviewModel>> get outDriverReview => _userReviewController.stream;

  User _user;
  BehaviorSubject<User> _userController;

  Stream<User> get outUser => _userController.stream;

  NotificationModelFirebase _notification;
  PublishSubject<NotificationModelFirebase> _notificationController;

  Stream<NotificationModelFirebase> get outNotification => _notificationController.stream;

  void _notificationHandler(NotificationModelFirebase notification) {
    _notificationController.add(_notification = notification);
  }

  void setReview(String uid) {
    _userReviewController = BehaviorController.catchStream(source: _db.getDriverReviews(uid));
  }

  UserBloc.instance() {
    _notificationController = PublishSubject(onListen: () {
      _notificationController.add(_notification);
    });
    StreamSubscription firebaseUserSub, userModelSub;
    _userController = BehaviorSubject(onListen: () {
      _userController.add(_user);
    }, onCancel: () {
      firebaseUserSub?.cancel();
    });

    firebaseUserSub = _firebaseUserController.outFirebaseUser.listen((firebaseUser) async {
      userModelSub?.cancel();
      if (firebaseUser == null) {
        _firebaseUserController.registrationLevel.complete(RegistrationLevel.LV1);
        return;
      }
      userModelSub = _db.getUser(firebaseUser).listen((userModel) async {
        if (userModel == null) {
          _firebaseUserController.registrationLevel.complete(RegistrationLevel.LV2);
          return;
        }

        _userController.add(_user = User(firebaseUser, userModel));
        if (!_firebaseUserController.registrationLevel.isCompleted) _firebaseUserController.registrationLevel.complete(RegistrationLevel.COMPLETE);
      });
    });
    _userController.onCancel = () => userModelSub?.cancel();
    _stripeController = DefaultStripeController(
      publishableKey: StripeConfig.STRIPE_PUBLIC_KEY,
      outUserId: outFirebaseUser.map((firebaseUser) => firebaseUser.uid),
      provider: _db,
    );
  }

  DefaultStripeController _stripeController;

  StripeManager get stripeManager => _stripeController;

  void updateNominative(String nominative, String email) async {
    final restUser = await outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateUser').call({
      'uid': restUser.uid,
      'nominative': nominative,
      'email': email,
    });
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

  Future<double> getDistance(LatLng start, LatLng end) async {
    return (await Geolocator().distanceBetween(start.latitude, start.longitude, end.latitude, end.longitude));
  }

  Future<double> getMockDistance() async {
    return 3.0;
  }
}

enum RegistrationLevel { LV1, LV2, COMPLETE }
