import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:resmedia_taporty_core/src/models/ProductModel.dart';
import 'package:resmedia_taporty_core/src/models/SupplierModel.dart';
import 'package:resmedia_taporty_core/src/models/ReviewModel.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';

mixin MixinSupplierProvider {
  final supplierCollection = Firestore.instance.collection(Collections.SUPPLIERS);

  Stream<List<SupplierModel>> getSupplierListStream() {
    return supplierCollection.snapshots().map((query) {
      return query.documents.map((snap) => SupplierModel.fromFirebase(snap)).toList();
    });
  }

  Future<List<SupplierModel>> getSupplierList() async {
    return (await supplierCollection.getDocuments()).documents.map((snap) {
      return SupplierModel.fromFirebase(snap);
    }).toList();
  }

  Stream<SupplierModel> getSupplierStream(String supplierId) {
    return supplierCollection.document(supplierId).snapshots().map(SupplierModel.fromFirebase);
  }

  Future<SupplierModel> getSupplier(String supplierId) async {
    return SupplierModel.fromFirebase(await supplierCollection.document(supplierId).get());
  }

  Future<List<ProductModel>> getProductList(String supplierId) async {
    return (await supplierCollection.document(supplierId).collection(Collections.PRODUCTS).where('state', isEqualTo: "ACCEPTED").getDocuments())
        .documents
        .map((querySnap) => ProductModel.fromFirebase(querySnap))
        .toList();
  }

  Stream<List<ProductModel>> getProductListStream(String supplierId) {
    return supplierCollection
        .document(supplierId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getFoodListStream(String supplierId) {
    return supplierCollection
        .document(supplierId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED") // ACCEPTED
        .where('type', isEqualTo: "food")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ProductModel>> getDrinkListStream(String supplierId) {
    return supplierCollection
        .document(supplierId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED") // ACCEPTED
        .where('type', isEqualTo: "drink")
        .snapshots()
        .map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ReviewModel>> getReviewListStream(String supplierId) {
    return supplierCollection.document(supplierId).collection('reviews').snapshots().map((querySnap) => FirebaseDatabase.fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
