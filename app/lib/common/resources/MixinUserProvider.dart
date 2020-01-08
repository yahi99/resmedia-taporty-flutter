import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:resmedia_taporty_flutter/config/Collections.dart';

mixin MixinUserProvider {
  final userCollection = Firestore.instance.collection(Collections.USERS);

  Future<UserModel> getUserById(String uid) async {
    return UserModel.fromFirebase(await userCollection.document(uid).get());
  }

  Stream<UserModel> getUserByIdStream(String uid) {
    return userCollection.document(uid).snapshots().map((snap) {
      return UserModel.fromFirebase(snap);
    });
  }
}
