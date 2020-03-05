import 'package:firebase_auth/firebase_auth.dart';
import 'package:resmedia_taporty_core/src/models/DriverModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';

extension DriverProviderExtension on DatabaseService {
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

  Future<void> setStripeActivationToken(String uid, String token) async {
    await driverCollection.document(uid).updateData({
      "stripeActivationToken": token,
    });
  }

  Future<void> updateIBAN(String uid, String iban) async {
    await driverCollection.document(uid).updateData({'iban': iban});
  }

  Future<void> updateDriverFcmToken(String uid, String fcmToken) async {
    await driverCollection.document(uid).updateData({'fcmToken': fcmToken});
  }

  Future<void> updateDriverProfileImage(String uid, String path) async {
    await driverCollection.document(uid).updateData({'imageUrl': path});
  }

  Future<void> updateDriverEmail(String uid, String email) async {
    await driverCollection.document(uid).updateData({'email': email});
  }

  Future<void> updateDriverNominative(String uid, String nominative) async {
    await driverCollection.document(uid).updateData({'nominative': nominative});
  }
}
