import 'package:easy_firebase/easy_firebase.dart';
import 'package:easy_firebase/src/database/UsersPath.dart';


mixin MixinFirestoreStripeProvider implements FirebaseDatabase {
  StripeCollection get stripe;

  Future<String> addStripeSource(String userId, Map<String, dynamic> map) async {
    final res = await cloudFunctions.getHttpsCallable(functionName: "addPaymentSource").call(map);
    return res.data['documentId'];
  }

  Stream<List<Map<String, dynamic>>> getStripeSources(String userId) {
    return fs.collection(stripe.id).document(userId).collection(stripe.$sources.id)
        .snapshots().map((querySnap) {
      return querySnap.documents.map((snap) => (snap.data..['id'] = snap.documentID)).toList();
    });
  }
}

class StripeCollection extends FirebaseCollection {
  final id = 'stripe_customers';

  final $sources = StripeSourceCollection();
  final $charges = StripeChargesCollection();
}

class StripeSourceCollection extends FirebaseCollection {
  final id = 'sources';
}

class StripeChargesCollection extends FirebaseCollection {
  final id = 'charges';
}