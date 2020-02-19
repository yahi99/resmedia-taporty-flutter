import 'package:firebase_auth/firebase_auth.dart';
import 'package:resmedia_taporty_core/src/models/UserModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';

extension UserProviderExtension on DatabaseService {
  Stream<UserModel> getUserStream(FirebaseUser user) {
    return userCollection.document(user.uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<UserModel> getUserById(String uid) async {
    return UserModel.fromFirebase(await userCollection.document(uid).get());
  }

  Stream<UserModel> getUserByIdStream(String uid) {
    return userCollection.document(uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }

  Future<void> updateUserFcmToken(String uid, String fcmToken) async {
    await userCollection.document(uid).updateData({'fcmToken': fcmToken});
  }

  Future<void> updateProfileImage(String uid, String path) async {
    await userCollection.document(uid).updateData({'imageUrl': path});
  }

  Future<void> updateUserEmail(String uid, String email) async {
    await userCollection.document(uid).updateData({'email': email});
  }

  Future<void> updateUserNominative(String uid, String nominative) async {
    await userCollection.document(uid).updateData({'nominative': nominative});
  }

  Future<void> updateUserPhoneNumber(String uid, String phoneNumber) async {
    await userCollection.document(uid).updateData({'phoneNumber': phoneNumber});
  }

  Future<void> updateNotifyApp(String uid, bool value) async {
    await userCollection.document(uid).updateData({'notifyApp': value});
  }

  Future createUser(String uid, String nominative, String email) async {
    await userCollection.document(uid).setData({
      ...UserModel(
        nominative: nominative,
        email: email,
        notifyApp: true,
      ).toJson(),
      "uid": uid,
    });
  }
}
