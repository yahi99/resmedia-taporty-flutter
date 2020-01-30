import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/ProductModel.dart';
import 'package:resmedia_taporty_core/src/models/SupplierModel.dart';
import 'package:resmedia_taporty_core/src/models/ReviewModel.dart';
import 'package:resmedia_taporty_core/src/config/Collections.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';

extension SupplierProviderExtension on DatabaseService {
  Stream<List<SupplierCategoryModel>> getSupplierCategoryListStream() {
    return supplierCategoryCollection.snapshots().map((query) {
      return query.documents.map((snap) => SupplierCategoryModel.fromFirebase(snap)).toList();
    });
  }

  Stream<SupplierCategoryModel> getSupplierCategoryStream(String categoryId) {
    return supplierCategoryCollection.document(categoryId).snapshots().map((snap) {
      return SupplierCategoryModel.fromFirebase(snap);
    });
  }

  Stream<List<SupplierModel>> getSupplierListStream() {
    return supplierCollection.snapshots().map((query) {
      return query.documents.map((snap) => SupplierModel.fromFirebase(snap)).toList();
    });
  }

  // TODO: Implementa il controllo sulla location
  Stream<List<SupplierModel>> getSupplierListByLocationStream(GeoPoint coordinates) {
    return supplierCollection.snapshots().map((query) {
      return query.documents.map((snap) => SupplierModel.fromFirebase(snap)).toList();
    });
  }

  Stream<SupplierModel> getSupplierStream(String supplierId) {
    return supplierCollection.document(supplierId).snapshots().map(SupplierModel.fromFirebase);
  }

  Stream<List<ProductModel>> getProductListStream(String supplierId) {
    return supplierCollection
        .document(supplierId)
        .collection(Collections.PRODUCTS)
        .where('state', isEqualTo: "ACCEPTED")
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, ProductModel.fromFirebase));
  }

  Stream<List<ReviewModel>> getReviewListStream(String supplierId) {
    return supplierCollection.document(supplierId).collection('reviews').snapshots().map((querySnap) => fromQuerySnaps(querySnap, ReviewModel.fromFirebase));
  }
}
