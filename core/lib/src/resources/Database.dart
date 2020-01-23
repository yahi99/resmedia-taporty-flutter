import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:resmedia_taporty_core/src/models/ReviewModel.dart';
import 'package:resmedia_taporty_core/src/resources/MixinOrderProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinSupplierProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinReviewProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinShiftProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinUserProvider.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';
import 'package:resmedia_taporty_core/src/models/UserModel.dart';

class Database extends FirebaseDatabase with MixinFirestoreStripeProvider, MixinSupplierProvider, MixinUserProvider, MixinShiftProvider, MixinOrderProvider, MixinReviewProvider, StripeProviderRule {
  static Database _db;

  Database.internal({
    @required Firestore firestore,
  }) : super.internal(
          UsersCollectionRule(),
          fs: firestore,
        );

  factory Database() {
    if (_db == null) {
      final fs = Firestore.instance;

      _db = Database.internal(
        firestore: fs,
      );
    }
    return _db;
  }

  final FirebaseStorage fbStorage = FirebaseStorage.instance;
  final CloudFunctions cloudFunctions = CloudFunctions();
  final StripeCollection stripe = StripeCollection();

  Future<void> createUserGoogle({@required String uid, @required String nominative, @required String email}) async {
    await fs.collection(Collections.USERS).document(uid).setData({'nominative': nominative, users.fcmToken: await fbMs.getToken(), 'email': email});
  }

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(Collections.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  // TODO: Rivedere
  Stream<List<ReviewModel>> getDriverReviews(String uid) {
    return fs.collection('users').document(uid).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
