import 'package:cloud_firestore/cloud_firestore.dart';
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
    return routes[routes.length - 3];
  }

  static V fromFirebase<V>(_FromJson<V> fromJson, DocumentSnapshot snap) {
    return snap.exists ? fromJson(snap.data..['path'] = snap.reference.path) : null;
  }

  @override
  bool operator ==(o) => o is FirebaseModel && o.path == path;

  @override
  int get hashCode => hash(path);
}

List<V> fromQuerySnaps<V extends FirebaseModel>(
  QuerySnapshot querySnap,
  V fromFirebase(DocumentSnapshot snap),
) {
  return querySnap.documents.map(fromFirebase).toList();
}
