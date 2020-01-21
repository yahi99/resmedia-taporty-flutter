import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:resmedia_taporty_core/src/models/UserModel.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';

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

  Future<void> updateUserImage(String path, String uid, String previous) async {
    //TODO: Delete previous image
    await userCollection.document(uid).updateData({'img': path});
    if (previous != null) _deleteFile(previous.split('/').last.split('?').first);
  }

  // TODO: Rivedere
  String _deleteFile(String path) {
    final StorageReference ref = FirebaseStorage.instance.ref();
    ref.child(path).delete();
    //_path = downloadUrl.toString();
    return 'ok';
  }
}
