
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersCollectionRule extends FirebaseCollection {
  final id = 'users';
  final String fcmToken;

  UsersCollectionRule({this.fcmToken: 'fcmToken'});
}



abstract class FirebaseCollection {
  String get id;

  const FirebaseCollection();

  CollectionReference col(Firestore fs) => fs.collection(id);

  DocumentReference doc(Firestore fs, [String idDoc]) => col(fs).document(idDoc);

  @override
  String toString() => id;
}


abstract class SubFirebaseCollection extends FirebaseCollection {
  final String _before;
  String get path => _before == null ? id : '$_before/$id';

  const SubFirebaseCollection([this._before]) : super();

  CollectionReference col(Firestore fs) => fs.collection(path);

  DocumentReference doc(Firestore fs, [String idDoc]) => col(fs).document(path+idDoc);
}



