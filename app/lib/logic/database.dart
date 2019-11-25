import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoder/model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:resmedia_taporty_flutter/control/model/ControlUsersModel.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/RestaurantRequestModel.dart';
import 'package:resmedia_taporty_flutter/data/collections.dart' as cl;
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/logic/Collections.dart';
import 'package:resmedia_taporty_flutter/logic/RestaurantDB.dart';
import 'package:resmedia_taporty_flutter/model/IncomeModel.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';

class Database extends FirebaseDatabase
    with MixinFirestoreStripeProvider, RestaurantDb, StripeProviderRule {
  static Database _db;

  Database.internal({
    @required Firestore fs,
  }) : super.internal(
          UsersCollectionRule(),
          fs: fs,
        );

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

  Future<void> createUser(
      {@required String uid, @required UserModel model}) async {
    await fs
        .collection(cl.USERS)
        .document(uid)
        .setData(model.toJson()..[users.fcmToken] = await fbMs.getToken());
  }

  Stream<List<UserOrderModel>> getUserOrders(String uid) {
    final data =
        fs.collection(cl.USERS).document(uid).collection('user_orders').snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => UserOrderModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<RestaurantOrderModel>> getCtrlOrders() {
    final data =
    fs.collection('control_orders').snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => RestaurantOrderModel.fromFirebase(snap))
          .toList();
    });
  }

  Future<CalendarModel> getDriverCalModel(
      String uid, String day, String startTime) async {
    return CalendarModel.fromFirebase(await fs
        .collection(cl.DAYS)
        .document(day)
        .collection(cl.TIMES)
        .document(startTime)
        .get());
  }

  Future<Coordinates> getPosition(String restId) async {
    final model = RestaurantModel.fromFirebase(
        await fs.collection(cl.RESTAURANTS).document(restId).get());
    return Coordinates(model.lat, model.lng);
  }

  Future<CalendarModel> getRestId(String day,String startTime)async{
    final list=(await fs.collection(cl.DAYS).document(day).collection(cl.TIMES).document(startTime).collection('restaurant_turns').where('isEmpty',isEqualTo: false).getDocuments()).documents;
    var min=CalendarModel.fromFirebase(list.first);
    for(int i=1;i<list.length;i++){
      var temp=CalendarModel.fromFirebase(list.elementAt(i));
      if(temp.occupied.length<min.occupied.length) min=temp;
    }
    return min;
  }

  Future<void> createRequestProduct(String id, String img, String category,
      String price, String quantity, String restaurantId, String cat) async {
    await fs.collection('product_requests').document(id).setData({
      'img': img,
      'category': category,
      'price': price,
      'quantity': quantity,
      'restaurantId': restaurantId,
      'cat': cat
    });
  }

  Future<void> pushReviewRest(String restId,int points,String strPoints,String oid,String uid,String nominative)async{
    final model=RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get());
    double average;
    int number;
    if(model.numberOfReviews!=null ) {
      average=(model.averageReviews*model.numberOfReviews+points)/(model.numberOfReviews+1);
      number=model.numberOfReviews+1;
    }
    else {
      average = points/1.0;
      number=1;
    }
    await fs.collection('restaurants').document(restId).updateData({'numberOfReviews':number,'averageReviews':average});
    await fs.collection('restaurants').document(restId).collection('reviews').add({'points':points,'strPoints':strPoints,'oid':oid,'userId':uid,'nominative':nominative});
  }

  Future<void> pushReviewDriver(String did,int points,String strPoints,String uid,String oid,String nominative)async{
    final model=UserModel.fromFirebase(await fs.collection('users').document(did).get());
    double average;
    int number;
    if(model.numberOfReviews!=null ) {
      average=(model.averageReviews*model.numberOfReviews+points)/(model.numberOfReviews+1);
      number=model.numberOfReviews+1;
    }
    else {
      average = points/1.0;
      number=1;
    }
    await fs.collection('users').document(did).updateData({'numberOfReviews':number,'averageReviews':average});
    await fs.collection('users').document(did).collection('reviews').add({'points':points,'strPoints':strPoints,'oid':oid,'userId':uid,'nominative':nominative});
  }

  Future<void> setReviewed(String uid,String oid)async{
    await fs.collection('users').document(uid).collection('user_orders').document(oid).updateData({'isReviewed':true});
  }

  Future<void> updateTime(String day,String isLunch,String startTime,String endTime,String restId)async{
    final rest=RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get());
    if(isLunch=='Pranzo'){
      Map<String,String> temp=rest.lunch;
      //print(rest.lunch.toString());
      if(temp!=null) {
        temp.remove(day);
        temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      else{
        temp=new Map<String,String>();
        temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'lunch':temp});
    }
    else{
      Map<String,String> temp=rest.dinner;
      print(rest.dinner);
      if(temp!=null) {
        temp.remove(day);
        temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      else{
        temp=new Map<String,String>();
        temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'dinner':temp});
    }
  }

  Future<void> cancelTime(String day,String isLunch,String restId)async{
    final rest=RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get());
    if(isLunch=='Pranzo'){
      Map<String,String> temp=rest.lunch;
      //print(rest.lunch.toString());
      if(temp!=null) {
        temp.remove(day);
        //temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'lunch':temp});
    }
    else{
      Map<String,String> temp=rest.dinner;
      print(rest.dinner);
      if(temp!=null) {
        temp.remove(day);
        //temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'dinner':temp});
    }
  }

  Future<void> updateImg(String path,String restId)async{
    //TODO delete previous image
    await fs.collection('restaurants').document(restId).updateData({'img':path});
  }

  Future<void> updateImgProduct(String path,ProductModel model)async{
    //TODO delete previous image
    await fs.collection('restaurants').document(model.restaurantId).collection(model.path.contains('foods')?'foods':'drinks').document(model.id).updateData({'img':path});
  }

  Future<void> deleteProduct(String product,String restId,String type)async{
    //TODO delete image
    await fs.collection('restaurants').document(restId).collection(type).document(product).delete();
  }

  Future<void> updateBank(RestaurantOrderModel model,double total)async{
    final restInc=IncomeModel.fromFirebase(await fs.collection('restaurants').document(model.restaurantId).collection('income').document(model.day).get());
    final totalInc=IncomeModel.fromFirebase(await fs.collection('income').document(model.day).get());
    if(restInc==null){
      await fs.collection('restaurants').document(model.restaurantId).collection('income').document(model.day).setData({'totalTransactions':1,'dailyTotal':total,'day':model.day});
      if(totalInc==null){
        await fs.collection('income').document(model.day).setData({'totalTransactions':1,'dailyTotal':total,'day':model.day});
      }
      else{
        await fs.collection('income').document(model.day).updateData({'totalTransactions':totalInc.totalTransactions+1,'dailyTotal':totalInc.dailyTotal+total,'day':model.day});
      }
    }
    else{
      await fs.collection('restaurants').document(model.restaurantId).collection('income').document(model.day).updateData({'totalTransactions':restInc.totalTransactions+1,'dailyTotal':restInc.dailyTotal+total,'day':model.day});
      await fs.collection('income').document(model.day).updateData({'totalTransactions':restInc.totalTransactions+1,'dailyTotal':restInc.dailyTotal+total,'day':model.day});
    }
  }

  Future<void> archiveProduct(ProductRequestModel model) async {
    await fs.collection('archived_product_requests').document(model.id).setData({
      'img': model.img,
      'category': model.category,
      'price': model.price,
      'quantity': model.quantity,
      'restaurantId': model.restaurantId,
      'cat': model.cat
    });
    await fs.collection('product_requests').document(model.id).delete();
  }

  void saveToken(String fcmToken,String uid)async{
    var tokens = fs
        .collection('users')
        .document(uid)
        .collection('tokens')
        .document(fcmToken);
    await tokens.setData({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }

  Future<void> addProduct(ProductRequestModel model)async{
    await fs.collection(cl.RESTAURANTS).document(model.restaurantId).collection(model.cat).document(model.id).setData({
      'img':model.img,
      'category':model.category,
      'price':model.price,
      'number':model.quantity,
      'restaurantId':model.restaurantId,
    });
    //await fs.collection('food_categories').document(model.category).setData({'translation':model.category});
    await fs.collection('product_requests').document(model.id).delete();
  }


  //TODO
  Future<void> addDriver(DriverRequestModel model)async{
    await fs.collection(cl.USERS).document(model.id).updateData({
      'km':model.km,
      'lat':model.lat,
      'lng':model.lng,
      'type':'driver',
    });
    //await fs.collection('users').document(model.id).updateData({'type':'driver'});
    await fs.collection('driver_requests').document(model.id).delete();
  }

  Future<void> changeStatus(ProductModel model)async{
    await fs.collection('restaurants').document(model.restaurantId).collection(model.path.contains('foods')?'foods':'drinks').document(model.id).updateData({'isDisabled':model.isDisabled?false:true});
  }

  Future<void> changeStatusRest(RestaurantModel model)async{
    await fs.collection('restaurants').document(model.id).updateData({'isDisabled':model.isDisabled?false:true});
  }

  Future<void> addRestaurant(RestaurantRequestModel model)async{
    await fs.collection(cl.RESTAURANTS).document(model.ragioneSociale).setData({
      'km':model.km,
      'lat':model.lat,
      'lng':model.lng,
      'img':model.img,
      'partitaIva':model.partitaIva,
      'prodType':model.prodType,
      'tipoEsercizio':model.tipoEsercizio,
      'address':model.address,
      'id':model.id,
      'lunch':Map<String,String>(),
      'dinner':Map<String,String>()
    });
    await fs.collection(cl.USERS).document(model.id).updateData({'restaurantId':model.ragioneSociale,'type':'restaurant'});
    //await fs.collection('food_categories').document(model.category).setData({'translation':model.category});
    await fs.collection('restaurant_requests').document(model.ragioneSociale).delete();
  }

  Stream<List<UserModel>> getUsersMod(){
    final data =
    fs.collection('users').where('type',isEqualTo:'restaurants').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => UserModel.fromFirebase(snap))
          .toList();
    });
  }

  String toMonth(int month) {
    if (month == 1) return 'JANUARY';
    if (month == 2) return 'FEBRUARY';
    if (month == 3) return 'MARCH';
    if (month == 4) return 'APRIL';
    if (month == 5) return 'MAY';
    if (month == 6) return 'JUNE';
    if (month == 7) return 'JULY';
    if (month == 8) return 'AUGUST';
    if (month == 9) return 'SEPTEMBER';
    if (month == 10) return 'OCTOBER';
    if (month == 11) return 'NOVEMBER';
    return 'DECEMBER';
  }

  Future<bool> addShift(String startTime,String endTime,String day,String number,String restId)async{
    final id=await fs.collection('days').document(day).collection('times').document(startTime).get();
    final rest=await fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).get();
    final days= await fs.collection('days').document(day).get();
    //already tried to insert!!!
    print(id.exists);
    print(rest.exists);
    final month=DateTime.tryParse(day).month.toString();
    if(id.exists && rest.exists) return true;
    if(!days.exists) await fs.collection('days').document(day).setData({});
    //no data for this time and day
    if(!id.exists) {
      //await fs.collection('days').document(day).setData({});
      await fs.collection('days').document(day).collection('times').document(
          startTime).setData({
        'startTime': startTime,
        'endTime': endTime,
        'day': day,
        'number': int.tryParse(number),
        'isEmpty': true,
        'free': [''],
        'occupied': [''],
      });
      await fs.collection('restaurants').document(restId).collection('turns').document(day+'§'+startTime).setData({'startTime':startTime,'endTime':endTime,'day':day,'month':toMonth(int.parse(month))});
      //fails if somehow there is data on this time and date but no document for startTime
      await fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).setData({
        'startTime':startTime,
        'endTime':endTime,
        'day':day,
        'number':int.tryParse(number),
        'isEmpty':true,
        'free':[''] ,
        'occupied':[''],
      });
      return false;
    }
    //id present so we update the start time document and add the restaurant document, which fails in case that it is present
    final model = CalendarModel.fromFirebase(id);
    fs.collection('days').document(day).collection('times').document(startTime).updateData({
      'startTime':startTime,
      'endTime':endTime,
      'day':day,
      'number':model.number+int.tryParse(number),
      'isEmpty':model.isEmpty,
      'free':model.free ,
      'occupied':model.occupied,
    });
    await fs.collection('restaurants').document(restId).collection('turns').document(day+'§'+startTime).setData({'startTime':startTime,'endTime':endTime,'day':day,'month':toMonth(int.parse(month))});
    fs.collection('days').document(day).collection('times').document(startTime).collection('restaurant_turns').document(restId).setData({
      'startTime':startTime,
      'endTime':endTime,
      'day':day,
      'number':int.tryParse(number),
      'isEmpty':true,
      'free':[''] ,
      'occupied':[''],
    });
    return false;
  }

  Future<void> deleteRestaurant(String restId)async{
    //TODO we need to delete everything in the collections inside plus the images stored
    await fs.collection('restaurants').document(restId).delete();
  }

  Future<void> upgradeToDriver({@required String uid,@required codiceFiscale,
      @required address,@required km,@required car,@required exp,@required Position pos,
      @required nominative})async{
    //await fs.collection(cl.USERS).document(uid).updateData({'isDriver':true});
    await fs.collection('driver_requests').document(uid).setData({'codiceFiscale':codiceFiscale,
        'address':address,'km':km,'mezzo':car,'experience':exp,'lat':pos.latitude,
        'lng':pos.longitude,'nominative':nominative});
  }
  Future<void> archiveDriver(DriverRequestModel model)async{
    //await fs.collection(cl.USERS).document(uid).updateData({'isDriver':true});
    await fs.collection('archived_driver_requests').document(model.id).setData({'codiceFiscale':model.codiceFiscale,
      'address':model.address,'km':model.km,'mezzo':model.mezzo,'experience':model.experience,'lat':model.lat,
      'lng':model.lng,'nominative':model.nominative});
    await fs.collection('driver_requests').document(model.id).delete();
  }

  Future<void> upgradeToVendor({@required String uid,@required String img,@required Position pos,
    @required double cop,@required rid,@required ragSociale,@required partitaIva,@required address,
    @required eseType,@required prodType})async{
    //await fs.collection(cl.USERS).document(uid).updateData({'restaurantId':rid});
    await fs.collection('restaurant_requests').document(uid).setData({'img':img,'lat':pos.latitude,
    'lng':pos.longitude,'km':cop,'ragioneSociale':ragSociale,'partitaIva':partitaIva,
    'address':address,'tipoEsercizio':eseType,'prodType':prodType});
  }

  Future<void> archiveVendor(RestaurantRequestModel model)async{
    //await fs.collection(cl.USERS).document(uid).updateData({'restaurantId':rid});
    await fs.collection('archived_restaurant_requests').document(model.id).setData({'img':model.img,'lat':model.lat,
      'lng':model.lng,'km':model.km,'ragioneSociale':model.ragioneSociale,'partitaIva':model.partitaIva,
      'address':model.address,'tipoEsercizio':model.tipoEsercizio,'prodType':model.prodType});
    await fs.collection('restaurant_requests').document(model.id).delete();
  }

  Future<void> editUser(String id,String type)async{
    await fs.collection('users').document(id).updateData({'type':type});
  }

  Future<void> createOrder(
      {@required String uid,
        @required String phone,
      @required Cart model,
      @required String driver,
      @required Position userPos,
      @required String addressR,
      @required String startTime,
      @required String nominative,
      @required String day,
      @required String endTime,
      @required String restAdd,
      @required String fingerprint}) async {
    final id = (await fs
            .collection(cl.RESTAURANTS)
            .document(model.products.first.restaurantId)
            .collection('restaurant_orders')
            .add(model.toJson()
              ..['restaurantId'] = model.products.first.restaurantId
              ..['timeR'] = DateTime.now().toString()
              ..['state'] = 'PENDING'
              ..['driver'] = driver
              ..['startTime'] = startTime
              ..['uid'] = uid
              ..['nominative'] = nominative
              ..['endTime'] = endTime
              ..['addressR'] = addressR
              ..['fingerprint']=fingerprint
              ..['day']=day
              ..['phone']=phone))
        .documentID;
    await fs
        .collection(cl.USERS)
        .document(uid)
        .collection('user_orders')
        .document(id)
        .setData(model.toJson()
          ..['restaurantId'] = model.products.first.restaurantId
          ..['timeR'] = DateTime.now().toString()
          ..['state'] = 'PENDING'
          ..['driver'] = driver
          ..['uid'] = uid
          ..['endTime']=endTime
          ..['day']=day
          ..['phone']=phone);
    await fs
        .collection(cl.USERS)
        .document(driver)
        .collection('driver_orders')
        .document(id)
        .setData(model.toJson()
          ..['titleS'] = model.products.first.restaurantId
          ..['timeR'] = DateTime.now().toString()
          ..['nominative'] = nominative
          ..['addressS'] = restAdd
          ..['state'] = 'PENDING'
          ..['titleS'] = uid
          ..['addressR'] = addressR
          ..['latR'] = userPos.latitude
          ..['lngR'] = userPos.longitude
          ..['phone']=phone
          ..['uid'] = uid
          ..['restId'] = model.products.first.restaurantId
          ..['day']=day
          ..['endTime']=endTime);
    await fs
        .collection(cl.RESTAURANTS)
        .document(model.products.first.restaurantId)
        .collection('control_orders')
        .document(id)
        .setData(model.toJson()
      ..['restaurantId'] = model.products.first.restaurantId
      ..['timeR'] = DateTime.now().toString()
      ..['state'] = 'PENDING'
      ..['driver'] = driver
      ..['startTime'] = startTime
      ..['uid'] = uid
      ..['nominative'] = nominative
      ..['endTime'] = endTime
      ..['addressR'] = addressR
      ..['fingerprint']=fingerprint
      ..['day']=day
      ..['phone']=phone);
  }

  /*Future<void> updateState({@required String uid, @required Cart model}) async {
    final old=fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).document('id').get();
    await fs.collection(cl.RESTAURANTS).document(model.products.first.restaurantId).collection(cl.ORDERS).document('id').updateData(data).add(
        model.toJson()..['restaurantId']=model.products.first.restaurantId..['time']=DateTime.now().toString()
          ..['state']='In Accettazione');
  }*/

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(cl.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<String> uploadImage(String path, File imageFile) async {
    StorageReference ref =
        fbs.ref().child(path).child(imageFile.path.split('/').last);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<RestaurantModel> get(String id) async {
    final res = await fs.document(id).get();
    return RestaurantModel.fromJson(res.data);
  }

  Stream<List<RestaurantOrderModel>> getRestaurantOrders(String restaurantId) {
    final data = fs
        .collection(cl.RESTAURANTS)
        .document(restaurantId)
        .collection('restaurant_orders')
        .snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => RestaurantOrderModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<TurnModel>> getTurns(String uid) {
    final data =
        fs.collection(cl.USERS).document(uid).collection(cl.TURNS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => TurnModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<TurnModel>> getTurnsRest(String restId) {
    final data =
    fs.collection(cl.RESTAURANTS).document(restId).collection(cl.TURNS).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => TurnModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<ShiftModel>> getUsersTurn(String day) {
    final data =
        fs.collection(cl.DAYS).document(day).collection(cl.TIMES).snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => ShiftModel.fromFirebase(snap))
          .toList();
    });
  }

  Future<void> updateDeliveryFee(double fee,String restId)async{
    await fs.collection('restaurants').document(restId).updateData({'deliveryFee':fee});
  }

  Future<void> updateProductPrice(double price,ProductModel model)async{
    await fs.collection('restaurants').document(model.restaurantId).collection(model.path.contains('foods')?'foods':'drinks').document(model.id).updateData({'price':price});
  }

  Future<void> updateKm(double km,String restId)async{
    await fs.collection('restaurants').document(restId).updateData({'km':km});
  }

  Stream<List<CalendarModel>> getShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final data = fs
        .collection(cl.DAYS)
        .document(now.toIso8601String())
        .collection(cl.TIMES)
        .snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => CalendarModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<IncomeModel> getRestIncome(DateTime now,String restId) {
    //final temp=.replaceAll(' ', 'T');
    return fs
        .collection('restaurants')
        .document(restId)
        .collection('income')
        .document(now.toIso8601String())
        .snapshots().map((snap) {
          return IncomeModel.fromFirebase(snap);
        });
  }

  Stream<IncomeModel> getTotalIncome(DateTime now){
    //final temp=.replaceAll(' ', 'T');
    return fs
        .collection('income')
        .document(now.toIso8601String())
        .snapshots().map((snap) {
      return IncomeModel.fromFirebase(snap);
    });
  }

  /*Stream<List<CalendarModel>> getAvailableShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final datas="${now.year}-${now.month < 10 ? "0" + now.month.toString() : now.month}-${now.day < 10 ? "0" + now.day.toString() : now.day}T00:00:00.000";
    print(datas);
    final data = fs
        .collection(cl.DAYS)
    // Questa riga incasinata è la correzione di come si tentava di recuperare gli orari prima: tu facevi la ricerca di un documento che era il formato iso della stringa del momento.nn
    // Il nome del documento sul database è il formato iso della stringa del giorno alle 00:00.
    /// NON SAREBBE MEGLIO ORGANIZZARE IL TUTTO SOLO NOMINANDO IL DOCUMENTO PER IL GIORNO?
        .document(
            "${now.year}-${now.month < 10 ? "0" + now.month.toString() : now.month}-${now.day < 10 ? "0" + now.day.toString() : now.day}T00:00:00.000")
        .collection(cl.TIMES)
        .where('isEmpty', isEqualTo: false)
        .snapshots();

    // TODO: Qui non funziona.

    return data.map((query) {
      debugPrint(query.documents.toString());
      return query.documents
          .map((snap) => CalendarModel.fromFirebase(snap))
          .toList();
    });
  }*/

  Stream<List<CalendarModel>> getAvailableShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final datas = now.toIso8601String();
    final data = fs
        .collection(cl.DAYS)
        .document(now.toIso8601String())
        .collection(cl.TIMES)
        .where('isEmpty', isEqualTo: false)
        .snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => CalendarModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<DriverOrderModel>> getDriverOrders(String uid) {
    final data =
        fs.collection(cl.USERS).document(uid).collection('driver_orders').snapshots();
    print('lol');
    return data.map((query) {
      return query.documents
          .map((snap) => DriverOrderModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<ProductRequestModel>> getRequests() {
    final data =
    fs.collection('product_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => ProductRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Future<void> updateDescription(String description,String restId)async{
    await fs.collection('restaurants').document(restId).updateData({'description':description});
  }

  Stream<List<ProductRequestModel>> getArchivedRequests() {
    final data =
    fs.collection('archived_product_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => ProductRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<UserModel>> getUsersControl() {
    final data =
    fs.collection('users').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => UserModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<UserModel>> getAdminsControl() {
    final data =
    fs.collection('users').where('type',isEqualTo:'admin').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => UserModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<DriverRequestModel>> getDriverRequests() {
    final data =
    fs.collection('driver_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => DriverRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<DriverRequestModel>> getArchivedDriverRequests() {
    final data =
    fs.collection('archived_driver_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => DriverRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<RestaurantRequestModel>> getRestaurantRequests() {
    final data =
    fs.collection('restaurant_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => RestaurantRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Stream<List<RestaurantRequestModel>> getArchivedRestaurantRequests() {
    final data =
    fs.collection('archived_restaurant_requests').snapshots();
    return data.map((query) {
      return query.documents
          .map((snap) => RestaurantRequestModel.fromFirebase(snap))
          .toList();
    });
  }

  Future<String> getRestaurantId(String uid) async {
    final res = await fs.collection(cl.USERS).document(uid).get();
    final data = res.data;
    return UserModel.fromJson(res.data).restaurantId;
  }

  Future<String> getUid(String uid) async {
    return UserModel.fromFirebase(
            await fs.collection(cl.USERS).document(uid).get())
        .nominative;
  }

  Future<RestaurantModel> getPos(String restId) async {
    return RestaurantModel.fromFirebase(
        await fs.collection(cl.RESTAURANTS).document(restId).get());
  }

  Future<void> updateState(String state, String uid, String oid, String restId,
      String driverId) async {
    await fs
        .collection(cl.USERS)
        .document(uid)
        .collection('user_orders')
        .document(oid)
        .updateData({'state': state});
    await fs
        .collection(cl.RESTAURANTS)
        .document(restId)
        .collection('restaurant_orders')
        .document(oid)
        .updateData({'state': state});
    await fs
        .collection(cl.USERS)
        .document(driverId)
        .collection('driver_orders')
        .document(oid)
        .updateData({'state': state});
  }

  Future<void> givePermission(String uid) async {
    await fs
        .collection(cl.USERS)
        .document(uid)
        .updateData({'type': 'control'});
    final users=(await ControlUsersModel.fromFirebase(await fs.collection('control_users').document('users').get())).users;
    users.add(uid);
    await fs.collection('control_users').document('users').updateData({'users':users});
  }

  Future<CalendarModel> getUsers(String date, String time) async {
    final res = await fs
        .collection(cl.DAYS)
        .document(date)
        .collection(cl.TIMES)
        .document(time)
        .get();
    //final data=res.data;
    return CalendarModel.fromJson(res.data);
  }

  Future<void> occupyDriver(String date, String time, List<String> free,
      List<String> occupied,String restId,String did) async {
    final model=CalendarModel.fromFirebase(await fs
        .collection(cl.DAYS)
        .document(date)
        .collection(cl.TIMES)
        .document(time)
        .collection('restaurant_turns')
        .document(restId)
        .get());
    model.occupied.add(did);
    if (free.length > 1)
      await fs
          .collection(cl.DAYS)
          .document(date)
          .collection(cl.TIMES)
          .document(time)
          .updateData({'free': free, 'occupied': occupied});
    else
      await fs
          .collection(cl.DAYS)
          .document(date)
          .collection(cl.TIMES)
          .document(time)
          .updateData({'free': free, 'occupied': occupied, 'isEmpty': true});
    await fs
        .collection(cl.DAYS)
        .document(date)
        .collection(cl.TIMES)
        .document(time)
        .collection('restaurant_turns')
        .document(restId)
        .updateData({'occupied':model.occupied});
    //final data=res.data;
    //return CalendarModel.fromJson(res.data);
  }
}

enum InviterError {
  NOT_EXIST_TABLE,
  NO_FREE_CHAIR,
  EMAIL_NOT_EXIST,
  PHONE_NUMBER_NOT_EXIST,
}
