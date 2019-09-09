import 'dart:async';

import 'package:cloud_functions/cloud_functions.dart';
import 'package:dash/dash.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/main.dart';
import 'package:mobile_app/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

import '../database.dart';

class UserBloc with MixinFirebaseUserManager implements Bloc {
  final Database _db = Database();

  @protected
  dispose() {
    _userController.close();
    _fcmTokenSubscription?.cancel();
    _notificationController.close();
  }

  final FirebaseUserController _firebaseUserController =
      FirebaseUserController();

  FirebaseUserManager get firebaseUserManager => _firebaseUserController;

  User _user;
  BehaviorSubject<User> _userController;

  Stream<User> get outUser => _userController.stream;

  StreamSubscription<String> _fcmTokenSubscription;

  NotificationModelFirebase _notification;
  PublishSubject<NotificationModelFirebase> _notificationController;

  Stream<NotificationModelFirebase> get outNotification =>
      _notificationController.stream;

  void _notificationHandler(NotificationModelFirebase notification) {
    _notificationController.add(_notification = notification);
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

    firebaseUserSub =
        _firebaseUserController.outFirebaseUser.listen((firebaseUser) async {
      userModelSub?.cancel();
      print(firebaseUser);
      if (firebaseUser == null) {
        _firebaseUserController.registrationLevel
            .complete(RegistrationLevel.LV1);
        return;
      }
      userModelSub = _db.getUser(firebaseUser).listen((userModel) async {
        print(userModel);
        if (userModel == null) {
          _firebaseUserController.registrationLevel
              .complete(RegistrationLevel.LV2);
          return;
        }

        if (userModel.fcmToken != _user?.model?.fcmToken) {
          _fcmTokenSubscription?.cancel();
          _fcmTokenSubscription = await _db.autoRefreshFcmToken(
            userModel,
            notificationFunctions:
                FirebaseNotificationFunctions.all((model) async {
              _notificationHandler(model);
            }),
          );
        }

        _userController.add(_user = User(firebaseUser, userModel));
        if (!_firebaseUserController.registrationLevel.isCompleted)
          _firebaseUserController.registrationLevel
              .complete(RegistrationLevel.COMPLETE);
      });
    });
    _userController.onCancel = () => userModelSub?.cancel();
    _stripeController = DefaultStripeController(
      publishableKey: STRIPE_PUBLIC_KEY,
      outUserId: outFirebaseUser.map((firebaseUser) => firebaseUser.uid),
      provider: _db,
    );
  }

  DefaultStripeController _stripeController;

  StripeManager get stripeManager => _stripeController;

  void updateNominative(String nominative, String email) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance.getHttpsCallable(functionName: 'updateUser').call({
      'uid': restUser.uid,
      'nominative': nominative,
      'email': email,
    });
  }

  void updateNotifyEmail(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateNotifyEmail')
        .call({'uid': restUser.uid, 'notifyEmail': value});
  }

  void updateOffersSms(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateOffersSms')
        .call({'uid': restUser.uid, 'offersSms': value});
  }

  void updateNotifySms(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateNotifySms')
        .call({'uid': restUser.uid, 'notifySms': value});
  }

  void updateNotifyApp(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateNotifyApp')
        .call({'uid': restUser.uid, 'notifyApp': value});
  }

  void updateOffersEmail(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateOffersEmail')
        .call({'uid': restUser.uid, 'offersEmail': value});
  }

  void updateOffersApp(bool value) async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    CloudFunctions.instance
        .getHttpsCallable(functionName: 'updateOffersApp')
        .call({'uid': restUser.uid, 'offersApp': value});
  }

  Future<double> getDistance(LatLng start, LatLng end) async {
    return (await Geolocator().distanceBetween(
        start.latitude, start.longitude, end.latitude, end.longitude));
  }

  Future<double> getMockDistance() async {
    return 3.0;
  }

  factory UserBloc.of() => $Provider.of<UserBloc>();

  factory UserBloc.init({FirebaseNotificationFunctions notificationFunctions}) {
    final bloc = UserBloc.of();
    return bloc;
  }

  static void close() => $Provider.dispose<UserBloc>();
}

enum RegistrationLevel { LV1, LV2, COMPLETE }
