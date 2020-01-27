import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:resmedia_taporty_core/src/models/ReviewModel.dart';
import 'package:resmedia_taporty_core/src/resources/MixinDriverProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinOrderProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinSupplierProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinReviewProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinShiftProvider.dart';
import 'package:resmedia_taporty_core/src/resources/MixinUserProvider.dart';

class DatabaseService extends FirebaseDatabase
    with MixinFirestoreStripeProvider, MixinSupplierProvider, MixinUserProvider, MixinDriverProvider, MixinShiftProvider, MixinOrderProvider, MixinReviewProvider, StripeProviderRule {
  static DatabaseService _db;

  DatabaseService.internal({
    @required Firestore firestore,
  }) : super.internal(
          UsersCollectionRule(),
          fs: firestore,
        );

  factory DatabaseService() {
    if (_db == null) {
      final fs = Firestore.instance;

      _db = DatabaseService.internal(
        firestore: fs,
      );
    }
    return _db;
  }

  final FirebaseStorage fbStorage = FirebaseStorage.instance;
  final CloudFunctions cloudFunctions = CloudFunctions();
  final StripeCollection stripe = StripeCollection();

  // TODO: Rivedere
  Stream<List<ReviewModel>> getDriverReviews(String uid) {
    return fs.collection('users').document(uid).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
