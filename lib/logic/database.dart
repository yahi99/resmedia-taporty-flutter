import 'dart:async';
import 'dart:io';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
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

  Stream<List<UserOrderModel>> getUserOrders(String uid) {
    final data=fs.collection(cl.USERS).document(uid).collection(cl.ORDERS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents.map((snap) => UserOrderModel.fromFirebase(snap)).toList();
    });
  }

  Future<CalendarModel> getDriverCalModel(String uid,String day,String startTime)async{
    return CalendarModel.fromFirebase(await fs.collection(cl.DAYS).document(day).collection(cl.TIMES).document(startTime).get());
  }

  Future<void> createRequestProduct(String id,String img,String category,String price,String quantity,String restaurantId,String cat)async{
    await fs.collection('product_requests').document(id).setData({'img':img,'category':category,'price':price,'quantity':quantity,'restaurantId':restaurantId,'cat':cat});
  }

  Future<void> createOrder({@required String uid, @required Cart model,@required String driver
    ,@required Position userPos,@required String addressR,@required String startTime,@required String nominative,@required String endTime}) async {
    final id=(await fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).add(
        model.toJson()..['restaurantId']=model.products.first.restaurantId..['timeR']=new DateTime.now().toString()
    ..['state']='PENDING'..['driver']=driver..['startTime']=startTime..['uid']=uid..['nominative']=nominative..['endTime']=endTime..['addressR']=addressR)).documentID;
    await fs.collection(cl.USERS).document(uid).collection(cl.ORDERS).document(id).setData(
        model.toJson()..['restaurantId']=model.products.first.restaurantId..['timeR']=new DateTime.now().toString()
          ..['state']='PENDING'..['driver']=driver..['uid']=uid);
    await fs.collection(cl.USERS).document(driver).collection(cl.ORDERS).document(id).setData(
        model.toJson()..['titleS']=model.products.first.restaurantId..['timeR']=new DateTime.now().toString()
          ..['state']='PENDING'..['titleS']=uid..['addressR']=addressR
        ..['latR']=userPos.latitude..['lngR']=userPos.longitude..['uid']=uid..['restId']=model.products.first.restaurantId);
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

  Stream<List<RestaurantOrderModel>> getRestaurantOrders(String restaurantId) {
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

  Stream<List<CalendarModel>> getAvailableShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final data=fs.collection(cl.DAYS).document(now.toIso8601String()).collection(cl.TIMES).where('isEmpty',isEqualTo: false).snapshots();
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

  Future<String> getUid(String uid)async{
    return UserModel.fromFirebase(await fs.collection(cl.USERS).document(uid).get()).nominative;
  }

  Future<void> updateState(String state,String uid,String oid,String restId,String driverId)async{
    await fs.collection(cl.USERS).document(uid).collection(cl.ORDERS).document(oid).updateData({'state':state});
    await fs.collection(cl.RESTAURANTS).document(restId).collection(cl.ORDERS).document(oid).updateData({'state':state});
    await fs.collection(cl.USERS).document(driverId).collection(cl.ORDERS).document(oid).updateData({'state':state});
  }

  Future<CalendarModel> getUsers(String date,String time) async {
    final res = await fs.collection(cl.DAYS).document(date).collection(cl.TIMES).document(time).get();
    //final data=res.data;
    return CalendarModel.fromJson(res.data);
  }

  Future<void> occupyDriver(String date,String time,List<String> free,List<String> occupied) async {
    if(free.length>1) await fs.collection(cl.DAYS).document(date).collection(cl.TIMES).document(time).updateData({'free':free,'occupied':occupied});
    else await fs.collection(cl.DAYS).document(date).collection(cl.TIMES).document(time).updateData({'free':free,'occupied':occupied,'isEmpty':true});
    //final data=res.data;
    //return CalendarModel.fromJson(res.data);
  }
}


enum InviterError {
  NOT_EXIST_TABLE, NO_FREE_CHAIR, EMAIL_NOT_EXIST, PHONE_NUMBER_NOT_EXIST,
}
