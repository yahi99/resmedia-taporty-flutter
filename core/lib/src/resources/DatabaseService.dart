import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';

class DatabaseService {
  static DatabaseService _db;

  Firestore firestore;
  Geoflutterfire geoFirestore;

  CollectionReference get userCollection => firestore.collection(Collections.USERS);
  CollectionReference get supplierCategoryCollection => firestore.collection(Collections.SUPPLIER_CATEGORIES);
  CollectionReference get driverCollection => firestore.collection(Collections.DRIVERS);
  CollectionReference get orderCollection => firestore.collection(Collections.ORDERS);
  CollectionReference get supplierCollection => firestore.collection(Collections.SUPPLIERS);
  CollectionReference get areaCollection => firestore.collection(Collections.AREAS);
  CollectionReference get shiftCollectionGroup => firestore.collectionGroup(Collections.SHIFTS);

  DatabaseService.internal({
    @required this.firestore,
    @required this.geoFirestore,
  });

  factory DatabaseService() {
    if (_db == null) {
      final fs = Firestore.instance;

      _db = DatabaseService.internal(
        firestore: fs,
        geoFirestore: Geoflutterfire(),
      );
    }
    return _db;
  }
}
