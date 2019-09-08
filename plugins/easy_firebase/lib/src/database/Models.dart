import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:path/path.dart';


typedef V _FromJson<V>(Map map);


abstract class FirebaseModel {
  @JsonKey(includeIfNull: false)
  final String path;

  FirebaseModel(this.path);

  String get id => path.split('/').last;
  
  String get parent {
    final routes = path.split('/');
    return routes[routes.length-3];
  }
  
  static V fromFirebase<V>(_FromJson<V> fromJson, DocumentSnapshot snap) {
    return snap.exists ? fromJson(snap.data..['path'] = snap.reference.path) : null;
  }

  @override
  bool operator ==(o) => o is FirebaseModel && o.path == path;

  @override
  int get hashCode => hash(path);
}


abstract class PartialDocumentModel extends JsonRule {
  final String id;

  PartialDocumentModel(this.id);
}


/// Use [user] for variable
abstract class UserBase<M extends UserFirebaseModel> {
  final M model;
  final FirebaseUser userFb;

  UserBase(this.userFb, this.model) : assert(model != null), assert(userFb != null);

  @override
  String toString() => 'UserBase(model: $model, userFb: $userFb)';
}


abstract class UserFirebaseModel extends FirebaseModel {
  @JsonKey(includeIfNull: false)
  final String fcmToken;

  UserFirebaseModel({String path, this.fcmToken}) : super(path);
}