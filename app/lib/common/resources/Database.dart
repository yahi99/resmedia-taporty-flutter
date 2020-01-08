import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ReviewModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinOrderProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinRestaurantProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinShiftProvider.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinUserProvider.dart';
import 'package:resmedia_taporty_flutter/config/Collections.dart';
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';

class Database extends FirebaseDatabase with MixinFirestoreStripeProvider, MixinRestaurantProvider, MixinShiftProvider, MixinUserProvider, MixinOrderProvider, StripeProviderRule {
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

  Future<void> createUser({@required String uid, @required UserModel model}) async {
    await fs.collection(Collections.USERS).document(uid).setData(model.toJson()..[users.fcmToken] = await fbMs.getToken());
  }

  Future<void> createUserGoogle({@required String uid, @required String nominative, @required String email}) async {
    await fs.collection(Collections.USERS).document(uid).setData({'nominative': nominative, users.fcmToken: await fbMs.getToken(), 'email': email});
  }

  // TODO: Rivedere
  Future<void> pushRestaurantReview(String restId, int points, String strPoints, String oid, String uid, String nominative) async {
    final model = RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get());
    double average;
    int number;
    if (model.numberOfReviews != null) {
      average = (model.averageReviews * model.numberOfReviews + points) / (model.numberOfReviews + 1);
      number = model.numberOfReviews + 1;
    } else {
      average = points / 1.0;
      number = 1;
    }
    await fs.collection('restaurants').document(restId).updateData({'numberOfReviews': number, 'averageReviews': average});
    await fs.collection('restaurants').document(restId).collection('reviews').add({'points': points, 'strPoints': strPoints, 'oid': oid, 'userId': uid, 'nominative': nominative});
  }

  // TODO: Rivedere
  Future<void> pushDriverReview(String driverId, int points, String strPoints, String uid, String orderId, String nominative) async {
    final model = UserModel.fromFirebase(await fs.collection('users').document(driverId).get());
    double average;
    int number;
    if (model.numberOfReviews != null) {
      average = (model.averageReviews * model.numberOfReviews + points) / (model.numberOfReviews + 1);
      number = model.numberOfReviews + 1;
    } else {
      average = points / 1.0;
      number = 1;
    }
    await fs.collection('users').document(driverId).updateData({'numberOfReviews': number, 'averageReviews': average});
    await fs.collection('users').document(driverId).collection('reviews').add({'points': points, 'strPoints': strPoints, 'oid': orderId, 'userId': uid, 'nominative': nominative});
  }

  Future<void> setOrderToReviewed(String uid, String orderId) async {
    await fs.collection('users').document(uid).collection('user_orders').document(orderId).updateData({'isReviewed': true});
  }

  // TODO: Rivedere
  //if the order deletes and the user has already paid the control panel can reimburs the user
  Future<void> deleteOrder(OrderModel order, String uid) async {
    await fs.collection('users').document(uid).collection('user_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('restaurants').document(order.restaurantId).collection('restaurant_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('users').document(order.driverId).collection('driver_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('control_orders').document(order.id).updateData({'state': 'CANCELLED'});
  }

  Future<void> updateUserImage(String path, String uid, String previous) async {
    //TODO: Delete previous image
    await fs.collection('users').document(uid).updateData({'img': path});
    if (previous != null) _deleteFile(previous.split('/').last.split('?').first);
  }

  // TODO: Rivedere
  String _deleteFile(String path) {
    final StorageReference ref = FirebaseStorage.instance.ref();
    ref.child(path).delete();
    //_path = downloadUrl.toString();
    return 'ok';
  }

  // TODO: Rivedere
  Future<bool> removeShiftRest(String startTime, String day, String restId) async {
    await fs.collection('restaurants').document(restId).collection('turns').document(day + '§' + startTime).delete();
    final modelRest = CalendarModel.fromFirebase(await fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).get());
    final model = CalendarModel.fromFirebase(await fs.collection('days').document(day).collection('times').document(startTime).get());
    final tempRest = modelRest.number;
    final temp = model.number;
    /*
    final free=modelRest.occupied;
    for(int i=1;i<free.length;i++){
      removeShiftDriver(startTime, day, free.elementAt(i));
    }
     */
    if (temp == tempRest) {
      await fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).delete();
      fs.collection('days').document(day).collection('times').document(startTime).delete();
      fs.collection('days').document(day).delete();
    } else {
      await fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).delete();
      fs.collection('days').document(day).collection('times').document(startTime).updateData({'number': (temp - tempRest)});
    }

    return true;
  }

  // TODO: Rivedere
  Future<bool> removeShiftDriver(String startTime, String day, String driver) async {
    print(day + '§' + startTime);
    await fs.collection('users').document(driver).collection('turns').document(day + '§' + startTime).delete();
    final model = CalendarModel.fromFirebase(await fs.collection('days').document(day).collection('times').document(startTime).get());
    final temp = model.free;
    temp.remove(driver);
    await fs.collection('days').document(day).collection('times').document(startTime).updateData({'free': temp});
    return true;
  }

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(Collections.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  // TODO: Rivedere
  Stream<List<TurnModel>> getTurns(String uid) {
    final data = fs.collection(Collections.USERS).document(uid).collection(Collections.TURNS).where('year', isEqualTo: DateTime.now().year).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => TurnModel.fromFirebase(snap)).toList();
    });
  }

  // TODO: Rivedere
  Stream<List<TurnModel>> getTurnsRest(String restId) {
    final data = fs.collection(Collections.RESTAURANTS).document(restId).collection(Collections.TURNS).where('year', isEqualTo: DateTime.now().year).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => TurnModel.fromFirebase(snap)).toList();
    });
  }

  // TODO: Rivedere
  Stream<List<ShiftModel>> getUsersTurn(String day) {
    final data = fs.collection('days').document(day).collection('times').snapshots();

    return data.map((query) {
      return query.documents.map((snap) => ShiftModel.fromFirebase(snap)).toList();
    });
  }

  // TODO: Rivedere
  Stream<List<CalendarModel>> getShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final data = fs.collection(Collections.DAYS).document(now.toIso8601String()).collection(Collections.TIMES).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => CalendarModel.fromFirebase(snap)).toList();
    });
  }

  // TODO: Rivedere
  Future<void> upgradeToDriver({@required String uid, @required codiceFiscale, @required address, @required km, @required car, @required exp, @required Position pos, @required nominative}) async {
    //await fs.collection(cl.USERS).document(uid).updateData({'isDriver':true});
    await fs
        .collection('driver_requests')
        .document(uid)
        .setData({'codiceFiscale': codiceFiscale, 'address': address, 'km': km, 'mezzo': car, 'experience': exp, 'lat': pos.latitude, 'lng': pos.longitude, 'nominative': nominative});
  }

  // TODO: Rivedere
  Future<void> upgradeToVendor(
      {@required String uid,
      @required String img,
      @required Position pos,
      @required double cop,
      @required rid,
      @required ragSociale,
      @required partitaIva,
      @required address,
      @required eseType,
      @required prodType}) async {
    //await fs.collection(cl.USERS).document(uid).updateData({'restaurantId':rid});
    await fs.collection('restaurant_requests').document(uid).setData(
        {'img': img, 'lat': pos.latitude, 'lng': pos.longitude, 'km': cop, 'ragioneSociale': ragSociale, 'partitaIva': partitaIva, 'address': address, 'tipoEsercizio': eseType, 'prodType': prodType});
  }

  // TODO: Rivedere
  Future<void> updateState(String state, String uid, String oid, String restId, String driverId) async {
    await fs.collection(Collections.USERS).document(uid).collection('user_orders').document(oid).updateData({'state': state});
    await fs.collection(Collections.RESTAURANTS).document(restId).collection('restaurant_orders').document(oid).updateData({'state': state});
    await fs.collection(Collections.USERS).document(driverId).collection('driver_orders').document(oid).updateData({'state': state});
    await fs.collection('control_orders').document(oid).updateData({'state': state});
  }

  // TODO: Rivedere
  Stream<List<ReviewModel>> getDriverReviews(String uid) {
    return fs.collection('users').document(uid).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
