import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/database/UsersPath.dart';
import 'package:easy_firebase/src/notification/NotificationModel.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';
import 'package:cloud_functions/cloud_functions.dart';


typedef Future<void> FirebaseNotification(NotificationModelFirebase model);


class FirebaseNotificationFunctions {
  final FirebaseNotification onMessage, onResume, onLaunch;

  FirebaseNotificationFunctions({this.onMessage, this.onResume, this.onLaunch});

  FirebaseNotificationFunctions.all(FirebaseNotification onNotification) : this(
    onMessage: onNotification, onResume: onNotification, onLaunch: onNotification,
  );
}


class FirebaseDatabase {
  final Firestore fs;
  final CloudFunctions cf;
  final FirebaseMessaging fbMs;

  final UsersCollectionRule users;

  FirebaseDatabase.internal(this.users, {
    Firestore fs,
    CloudFunctions cf,
    FirebaseMessaging fbMs,
  }) : this.fs = fs??Firestore(),
        this.cf = cf?? CloudFunctions(),
        this.fbMs = fbMs??FirebaseMessaging();

  Future<void> setUser(FirebaseUser user, JsonRule json, {bool merge: false}) {
    return fs.document(users.id)
        .setData(json.toJson(), merge: merge);
  }

  Future<void> updateFcmToken(UserFirebaseModel model, String fcmToken) {
    return fs.document(model.path).updateData({users.fcmToken: fcmToken});
  }

  Future<void> autoUpdateFcmToken(UserFirebaseModel model) async {
    final fcmToken = await fbMs.getToken();
    if (model.fcmToken == fcmToken) return null;
    return await updateFcmToken(model, fcmToken);
  }

  Future<StreamSubscription<String>> autoRefreshFcmToken(UserFirebaseModel model, {
    FirebaseNotificationFunctions notificationFunctions,
  }) async {
    if (Platform.isIOS) {
      fbMs.requestNotificationPermissions(
          IosNotificationSettings(sound: true, badge: true, alert: true));
      //fbMs.onIosSettingsRegistered.listen((IosNotificationSettings settings) {
      //  print("Impostazioni registrate: $settings ");
      //});
    }

    fbMs.configure(
      onMessage: (map) => notificationFunctions.onMessage(NotificationModelFirebase.fromJson(map)),
      onResume: (map) => notificationFunctions.onResume(NotificationModelFirebase.fromJson(map)),
      onLaunch: (map) => notificationFunctions.onLaunch(NotificationModelFirebase.fromJson(map)),
    );

    return fbMs.onTokenRefresh.listen((_fcmToken) {
      updateFcmToken(model, _fcmToken);
    });
  }



  Stream<List<V>> getDocuments<V extends FirebaseModel>(
    Iterable<String> documents, V fromFirebase(DocumentSnapshot snap),
  ) {
    return Observable.combineLatestList(
      documents.map((doc) => fs.document(doc).snapshots().map(fromFirebase)),
    );
  }

  Stream<List<V>> getDocumentsByCollection<V extends FirebaseModel>(
      CollectionReference collection, Iterable<String> documents, V fromFirebase(DocumentSnapshot snap),
      ) {
    if (documents.length == 0)
      return Observable.just([]);
    assert(collection != null && documents != null && fromFirebase != null);
    assert(documents.every((data) => data != null));
    return Observable.combineLatestList(
      documents.map((doc) {
        final ref = collection.document(doc);
        return ref.snapshots().map(fromFirebase);
      }).toList(),
    );
  }

  List<V> fromQuerySnaps<V extends FirebaseModel>(
    QuerySnapshot querySnap, V fromFirebase(DocumentSnapshot snap),
  ) {
    return querySnap.documents.map(fromFirebase).toList();
  }


}


class RenameCollection {
  final String name;
  final String newName;
  final List<RenameCollection> _subCollections;

  RenameCollection(
      this.name, this.newName, this._subCollections,
  );

  Future<void> renameCollection(Firestore firestore) async {
    final colRef = firestore.collection(name);
    await colRef.getDocuments().then((docs) async {
      print("$name to $newName");
      await Future.forEach<DocumentSnapshot>(docs.documents, (doc) async {

        print("${doc.documentID}");
        await colRef.document(doc.documentID).setData(doc.data);

        await Future.forEach<RenameCollection>(_subCollections, (collection) async {
          await RenameCollection(
            "$name/${doc.documentID}/${collection.name}",
            "$newName/${doc.documentID}/${collection.newName}",
            collection._subCollections,
          ).renameCollection(firestore);
        });
      });
    });
  }


}
