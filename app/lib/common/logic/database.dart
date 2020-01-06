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
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server/gmail.dart';
import 'package:resmedia_taporty_flutter/client/model/CartModel.dart';
import 'package:resmedia_taporty_flutter/data/collections.dart' as collections;
import 'package:resmedia_taporty_flutter/drivers/model/CalendarModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/common/logic/Collections.dart';
import 'package:resmedia_taporty_flutter/common/logic/RestaurantDB.dart';
import 'package:resmedia_taporty_flutter/common/model/IncomeModel.dart';
import 'package:resmedia_taporty_flutter/common/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:mailer/src/entities/address.dart' as address;

import 'bloc/UserBloc.dart';

class Database extends FirebaseDatabase with MixinFirestoreStripeProvider, RestaurantDb, StripeProviderRule {
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

  final RestaurantsCollection restaurants = const RestaurantsCollection();
  final TablesCollection tables = const TablesCollection();
  final StripeCollection stripe = StripeCollection();

  Future<void> createUser({@required String uid, @required UserModel model}) async {
    await fs.collection(collections.USERS).document(uid).setData(model.toJson()..[users.fcmToken] = await fbMs.getToken());
  }

  Future<void> createUserGoogle({@required String uid, @required String nominative, @required String email}) async {
    await fs.collection(collections.USERS).document(uid).setData({'nominative': nominative, users.fcmToken: await fbMs.getToken(), 'email': email});
  }

  Stream<List<UserModel>> getDriverList() {
    final data = fs.collection('users').where('type', isEqualTo: 'driver').snapshots();
    return data.map((query) {
      return query.documents.map((snap) => UserModel.fromFirebase(snap)).toList();
    });
  }

  Future<CalendarModel> getDriverCalendarModel(String uid, String day, String startTime) async {
    return CalendarModel.fromFirebase(await fs.collection(collections.DAYS).document(day).collection(collections.TIMES).document(startTime).get());
  }

  Future<Coordinates> getRestaurantPosition(String restaurantId) async {
    final model = RestaurantModel.fromFirebase(await fs.collection(collections.RESTAURANTS).document(restaurantId).get());
    return Coordinates(model.coordinates.latitude, model.coordinates.longitude);
  }

  Future<void> createRequestProduct(String id, String img, String category, String price, String quantity, String restaurantId, String cat) async {
    await fs
        .collection('product_requests')
        .document(id + '§' + restaurantId)
        .setData({'title': id, 'img': img, 'category': category, 'price': price, 'quantity': quantity, 'restaurantId': restaurantId, 'cat': cat});
  }

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

  /*Future<void> updateTime(String day, String isLunch, String startTime, String endTime, String restaurantId) async {
    final rest = RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restaurantId).get());
    if (isLunch == 'Pranzo') {
      Map<String, String> temp = rest.lunch;
      //print(rest.lunch.toString());
      if (temp != null) {
        temp.remove(day);
        temp.putIfAbsent(day, () => startTime + '-' + endTime);
      } else {
        temp = new Map<String, String>();
        temp.putIfAbsent(day, () => startTime + '-' + endTime);
      }
      await fs.collection('restaurants').document(restaurantId).updateData({'lunch': temp});
    } else {
      Map<String, String> temp = rest.dinner;
      print(rest.dinner);
      if (temp != null) {
        temp.remove(day);
        temp.putIfAbsent(day, () => startTime + '-' + endTime);
      } else {
        temp = new Map<String, String>();
        temp.putIfAbsent(day, () => startTime + '-' + endTime);
      }
      await fs.collection('restaurants').document(restaurantId).updateData({'dinner': temp});
    }
  }*/

  // TODO: Eliminazione immagine utente
  Future<void> deleteUser(String uid, String img) async {
    final turns = await fs.collection('users').document(uid).collection('turns').getDocuments();
    final orders = await fs.collection('users').document(uid).collection('user_orders').getDocuments();
    final driverOrders = await fs.collection('users').document(uid).collection('driver_orders').getDocuments();
    final reviews = await fs.collection('users').document(uid).collection('reviews').getDocuments();
    for (int i = 0; i < turns.documents.length; i++) {
      await fs.collection('users').document(uid).collection('turns').document(turns.documents.elementAt(i).documentID).delete();
    }
    for (int i = 0; i < orders.documents.length; i++) {
      await fs.collection('users').document(uid).collection('user_orders').document(orders.documents.elementAt(i).documentID).delete();
    }
    for (int i = 0; i < driverOrders.documents.length; i++) {
      await fs.collection('users').document(uid).collection('driver_orders').document(driverOrders.documents.elementAt(i).documentID).delete();
    }
    for (int i = 0; i < reviews.documents.length; i++) {
      await fs.collection('users').document(uid).collection('reviews').document(reviews.documents.elementAt(i).documentID).delete();
    }
    if (img != null) _deleteFile(img.split('/').last.split('?').first);
    await fs.collection('users').document(uid).delete();
  }

  /*Future<void> cancelTime(String day, String isLunch, String restId) async {
    final rest = RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get());
    if (isLunch == 'Pranzo') {
      Map<String, String> temp = rest.lunch;
      //print(rest.lunch.toString());
      if (temp != null) {
        temp.remove(day);
        //temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'lunch': temp});
    } else {
      Map<String, String> temp = rest.dinner;
      print(rest.dinner);
      if (temp != null) {
        temp.remove(day);
        //temp.putIfAbsent(day, () => startTime + ':' + endTime);
      }
      await fs.collection('restaurants').document(restId).updateData({'dinner': temp});
    }
  }*/

  //if the order deletes and the user has already paid the control panel can reimburs the user
  Future<void> deleteOrder(OrderModel order, String uid) async {
    await fs.collection('users').document(uid).collection('user_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('restaurants').document(order.restaurantId).collection('restaurant_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('users').document(order.driverId).collection('driver_orders').document(order.id).updateData({'state': 'CANCELLED'});
    await fs.collection('control_orders').document(order.id).updateData({'state': 'CANCELLED'});
  }

  Stream<UserModel> getUserModelById(String uid) {
    return fs.collection('users').document(uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<void> updateRestaurantImage(String path, String restId) async {
    //TODO delete previous image
    final img = RestaurantModel.fromFirebase(await fs.collection('restaurants').document(restId).get()).imageUrl;
    await fs.collection('restaurants').document(restId).updateData({'img': path});
    _deleteFile(img.split('/').last.split('?').first);
  }

  Future<void> updateUserImage(String path, String uid, String previous) async {
    //TODO delete previous image
    await fs.collection('users').document(uid).updateData({'img': path});
    if (previous != null) _deleteFile(previous.split('/').last.split('?').first);
  }

  String _deleteFile(String path) {
    final StorageReference ref = FirebaseStorage.instance.ref();
    ref.child(path).delete();
    //_path = downloadUrl.toString();
    return 'ok';
  }

  Future<void> deleteProduct(String product, String restId, String type) async {
    //TODO delete image
    await fs.collection('restaurants').document(restId).collection(type).document(product).delete();
  }

  void saveToken(String fcmToken, String uid) async {
    var tokens = fs.collection('users').document(uid).collection('tokens').document(fcmToken);
    await tokens.setData({
      'token': fcmToken,
      'createdAt': FieldValue.serverTimestamp(), // optional
      'platform': Platform.operatingSystem // optional
    });
  }

  String monthNameFromNumber(int month) {
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

  Future<void> updateRemember(bool remember) async {
    final uid = (await UserBloc.of().outFirebaseUser.first).uid;
    await fs.collection('users').document(uid).updateData({'remember': remember});
  }

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

  Future<bool> removeShiftDriver(String startTime, String day, String driver) async {
    print(day + '§' + startTime);
    await fs.collection('users').document(driver).collection('turns').document(day + '§' + startTime).delete();
    final model = CalendarModel.fromFirebase(await fs.collection('days').document(day).collection('times').document(startTime).get());
    final temp = model.free;
    temp.remove(driver);
    await fs.collection('days').document(day).collection('times').document(startTime).updateData({'free': temp});
    return true;
  }

  Future<void> createOrder(
      {@required String uid,
      @required String phone,
      @required CartModel model,
      @required String driver,
      @required Position userPos,
      @required String addressR,
      @required String startTime,
      @required String nominative,
      @required String day,
      @required String endTime,
      @required String restAdd,
      @required String fingerprint}) async {
    final id = (await fs.collection(collections.RESTAURANTS).document(model.products.first.restaurantId).collection('restaurant_orders').add(model.toJson()
          ..['restaurantId'] = model.products.first.restaurantId
          ..['timeR'] = DateTime.now().toString()
          ..['state'] = 'PENDING'
          ..['driver'] = driver
          ..['startTime'] = startTime
          ..['uid'] = uid
          ..['nominative'] = nominative
          ..['endTime'] = endTime
          ..['addressR'] = addressR
          ..['fingerprint'] = fingerprint
          ..['day'] = day
          ..['phone'] = phone
          ..['isPaid'] = false
          ..['isReviewed'] = false))
        .documentID;
    await fs.collection(collections.USERS).document(uid).collection('user_orders').document(id).setData(model.toJson()
      ..['restaurantId'] = model.products.first.restaurantId
      ..['timeR'] = DateTime.now().toString()
      ..['state'] = 'PENDING'
      ..['driver'] = driver
      ..['uid'] = uid
      ..['endTime'] = endTime
      ..['day'] = day
      ..['phone'] = phone);
    await fs.collection(collections.USERS).document(driver).collection('driver_orders').document(id).setData(model.toJson()
      ..['titleS'] = model.products.first.restaurantId
      ..['timeR'] = DateTime.now().toString()
      ..['nominative'] = nominative
      ..['addressS'] = restAdd
      ..['state'] = 'PENDING'
      ..['titleS'] = uid
      ..['addressR'] = addressR
      ..['latR'] = userPos.latitude
      ..['lngR'] = userPos.longitude
      ..['phone'] = phone
      ..['uid'] = uid
      ..['restId'] = model.products.first.restaurantId
      ..['day'] = day
      ..['endTime'] = endTime);
    await fs.collection('control_orders').document(id).setData(model.toJson()
      ..['restaurantId'] = model.products.first.restaurantId
      ..['timeR'] = DateTime.now().toString()
      ..['state'] = 'PENDING'
      ..['driver'] = driver
      ..['startTime'] = startTime
      ..['uid'] = uid
      ..['nominative'] = nominative
      ..['endTime'] = endTime
      ..['addressR'] = addressR
      ..['fingerprint'] = fingerprint
      ..['day'] = day
      ..['phone'] = phone
      ..['isPaid'] = false
      ..['isReviewed'] = false);
  }

  Stream<UserModel> getUser(FirebaseUser user) {
    return fs.collection(collections.USERS).document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Stream<UserModel> getUserModel(String id) {
    return fs.collection(collections.USERS).document(id).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Stream<UserModel> getUserCtrl(UserModel user) {
    return fs.collection(collections.USERS).document(user.id).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<String> uploadImage(String path, File imageFile) async {
    StorageReference ref = fbStorage.ref().child(path).child(imageFile.path.split('/').last);
    StorageUploadTask uploadTask = ref.putFile(imageFile);
    return await (await uploadTask.onComplete).ref.getDownloadURL();
  }

  Future<RestaurantModel> get(String id) async {
    final res = await fs.document(id).get();
    return RestaurantModel.fromJson(res.data);
  }

  Stream<OrderModel> getUserOrder(String uid, String oid) {
    return fs.collection(collections.USERS).document(uid).collection('user_orders').document(oid).snapshots().map((snap) {
      return OrderModel.fromFirebase(snap);
    });
  }

  Stream<List<TurnModel>> getTurns(String uid) {
    final data = fs.collection(collections.USERS).document(uid).collection(collections.TURNS).where('year', isEqualTo: DateTime.now().year).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => TurnModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<TurnModel>> getTurnsRest(String restId) {
    final data = fs.collection(collections.RESTAURANTS).document(restId).collection(collections.TURNS).where('year', isEqualTo: DateTime.now().year).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => TurnModel.fromFirebase(snap)).toList();
    });
  }

  Stream<List<ShiftModel>> getUsersTurn(String day) {
    final data = fs.collection(collections.DAYS).document(day).collection(collections.TIMES).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => ShiftModel.fromFirebase(snap)).toList();
    });
  }

  Future<void> updateDeliveryFee(double fee, String restId) async {
    await fs.collection('restaurants').document(restId).updateData({'deliveryFee': fee});
  }

  Future<void> updateProductPrice(double price, ProductModel model) async {
    await fs.collection('restaurants').document(model.restaurantId).collection(model.path.contains('foods') ? 'foods' : 'drinks').document(model.id).updateData({'price': price.toString()});
  }

  Future<void> updateKm(double km, String restId) async {
    await fs.collection('restaurants').document(restId).updateData({'km': km});
  }

  Stream<List<CalendarModel>> getShifts(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    final data = fs.collection(collections.DAYS).document(now.toIso8601String()).collection(collections.TIMES).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => CalendarModel.fromFirebase(snap)).toList();
    });
  }

  Stream<IncomeModel> getRestIncome(DateTime now, String restId) {
    //final temp=.replaceAll(' ', 'T');
    return fs.collection('restaurants').document(restId).collection('income').document(now.toIso8601String()).snapshots().map((snap) {
      return IncomeModel.fromFirebase(snap);
    });
  }

  Stream<IncomeModel> getTotalIncome(DateTime now) {
    //final temp=.replaceAll(' ', 'T');
    return fs.collection('income').document(now.toIso8601String()).snapshots().map((snap) {
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
    final data = fs.collection(collections.DAYS).document(now.toIso8601String()).collection(collections.TIMES).where('isEmpty', isEqualTo: false).snapshots();

    return data.map((query) {
      return query.documents.map((snap) => CalendarModel.fromFirebase(snap)).toList();
    });
  }

  Future<void> upgradeToDriver({@required String uid, @required codiceFiscale, @required address, @required km, @required car, @required exp, @required Position pos, @required nominative}) async {
    //await fs.collection(cl.USERS).document(uid).updateData({'isDriver':true});
    await fs
        .collection('driver_requests')
        .document(uid)
        .setData({'codiceFiscale': codiceFiscale, 'address': address, 'km': km, 'mezzo': car, 'experience': exp, 'lat': pos.latitude, 'lng': pos.longitude, 'nominative': nominative});
  }

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

  Future<RestaurantModel> getPos(String restId) async {
    return RestaurantModel.fromFirebase(await fs.collection(collections.RESTAURANTS).document(restId).get());
  }

  Future<void> updateState(String state, String uid, String oid, String restId, String driverId) async {
    await fs.collection(collections.USERS).document(uid).collection('user_orders').document(oid).updateData({'state': state});
    await fs.collection(collections.RESTAURANTS).document(restId).collection('restaurant_orders').document(oid).updateData({'state': state});
    await fs.collection(collections.USERS).document(driverId).collection('driver_orders').document(oid).updateData({'state': state});
    await fs.collection('control_orders').document(oid).updateData({'state': state});
  }

  Future<CalendarModel> getDrivers(String date, String time) async {
    final res = await fs.collection(collections.DAYS).document(date).collection(collections.TIMES).document(time).get();
    //final data=res.data;
    return CalendarModel.fromJson(res.data);
  }

  Future<void> occupyDriver(String date, String time, List<String> free, List<String> occupied, String restId, String did) async {
    final model = CalendarModel.fromFirebase(await fs.collection(collections.DAYS).document(date).collection(collections.TIMES).document(time).collection('restaurant_turns').document(restId).get());
    model.occupied.add(did);
    if (free.length > 1)
      await fs.collection(collections.DAYS).document(date).collection(collections.TIMES).document(time).updateData({'free': free, 'occupied': occupied});
    else
      await fs.collection(collections.DAYS).document(date).collection(collections.TIMES).document(time).updateData({'free': free, 'occupied': occupied, 'isEmpty': true});
    await fs.collection(collections.DAYS).document(date).collection(collections.TIMES).document(time).collection('restaurant_turns').document(restId).updateData({'occupied': model.occupied});
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
