import 'dart:async';
import 'dart:io';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:mobile_app/data/collections.dart' as cl;
import 'package:mobile_app/drivers/model/CalendarModel.dart';
import 'package:mobile_app/drivers/model/OrderModel.dart';
import 'package:mobile_app/drivers/model/ShiftModel.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';
import 'package:mobile_app/model/OrderModel.dart';
import 'package:mobile_app/model/RestaurantModel.dart';
import 'package:mobile_app/model/UserModel.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:mobile_app/logic/RestaurantDB.dart';
import 'package:mobile_app/logic/Collections.dart';

class Database extends FirebaseDatabase with MixinFirestoreStripeProvider,RestaurantDb, StripeProviderRule {
  static Database _db;

  Database.internal({
    @required Firestore fs,
  }) : super.internal(UsersCollectionRule(), fs: fs, );

  factory Database() {
    if (_db == null) {
      final fs = Firestore.instance;

      _db = Database.internal(
        fs: fs,
      );
    }
    return _db;
  }

  final FirebaseStorage fbs = FirebaseStorage.instance;
  final CloudFunctions cf = CloudFunctions();

  final RestaurantsCollection restaurants = const RestaurantsCollection();
  final TablesCollection tables = const TablesCollection();
  final StripeCollection stripe = StripeCollection();

  Future<void> createUser({@required String uid, @required UserModel model}) async {
    await fs.collection(cl.USERS).document(uid).setData(
        model.toJson()..[users.fcmToken] = await fbMs.getToken());
  }

  Future<void> createOrder({@required String uid, @required Cart model}) async {
    await fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).add(
        model.toJson()..['restaurantId']=model.products.first.restaurantId..['time']=new DateTime.now().toString()
    ..['state']='In Accettazione');
  }

  /*Future<void> updateState({@required String uid, @required Cart model}) async {
    final old=fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).document('id').get();
    await fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).document('id').updateData(data).add(
        model.toJson()..['restaurantId']=model.products.first.restaurantId..['time']=new DateTime.now().toString()
          ..['state']='In Accettazione');
  }*/

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(cl.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<String> uploadImage(String path, File imageFile) async {
    StorageReference ref = fbs.ref().child(path).child(imageFile.path.split('/').last);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<RestaurantModel> get(String id) async {
    final res = await fs.document(id).get();
    return RestaurantModel.fromJson(res.data);
  }

  Stream<List<RestaurantOrderModel>> getRestaurantOrders(String uid,String restaurantId) {
    final data=fs.collection(cl.RESTAURANTS).document(restaurantId).collection(cl.ORDERS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => RestaurantOrderModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<TurnModel>> getTurns(String uid) {
    final data=fs.collection(cl.USERS).document(uid).collection(cl.TURNS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => TurnModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<ShiftModel>> getUsersTurn(String day) {
    final data=fs.collection(cl.DAYS).document(day).collection(cl.TIMES).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => ShiftModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<CalendarModel>> getShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final data=fs.collection(cl.DAYS).document(now.toIso8601String()).collection(cl.TIMES).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => CalendarModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<DriverOrderModel>> getDriverOrders(String uid) {
    final data=fs.collection(cl.USERS).document(uid).collection(cl.ORDERS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => DriverOrderModel.fromFirebase(snap)).toList();
    });
  }

  Future<String> getRestaurantId(String uid) async {
    final res = await fs.collection(cl.USERS).document(uid).get();
    final data=res.data;
    return UserModel.fromJson(res.data).restaurantId;
  }
}


enum InviterError {
  NOT_EXIST_TABLE, NO_FREE_CHAIR, EMAIL_NOT_EXIST, PHONE_NUMBER_NOT_EXIST,
}