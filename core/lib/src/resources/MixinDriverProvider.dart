import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:resmedia_taporty_core/src/models/DriverModel.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';

mixin MixinDriverProvider {
  final driverCollection = Firestore.instance.collection(Collections.DRIVERS);

  Stream<DriverModel> getDriverStream(FirebaseUser driver) {
    return driverCollection.document(driver.uid).snapshots().map((snap) {
      return DriverModel.fromFirebase(snap);
    });
  }

  Future<DriverModel> getDriverById(String uid) async {
    return DriverModel.fromFirebase(await driverCollection.document(uid).get());
  }

  Stream<DriverModel> getDriverByIdStream(String uid) {
    return driverCollection.document(uid).snapshots().map((snap) {
      return DriverModel.fromFirebase(snap);
    });
  }

  Future<void> updateProfileImage(String uid, String path) async {
    await driverCollection.document(uid).updateData({'imageUrl': path});
  }

  Future<void> updateEmail(String uid, String email) async {
    await driverCollection.document(uid).updateData({'email': email});
  }

  Future<void> updateNominative(String uid, String nominative) async {
    await driverCollection.document(uid).updateData({'nominative': nominative});
  }
}
