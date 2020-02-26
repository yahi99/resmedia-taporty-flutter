import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';

extension ShiftProvider on DatabaseService {
  Future<List<ShiftModel>> getAvailableShifts(Timestamp startTime, GeoPoint supplierCoordinates) async {
    var query = shiftCollection.where("startTime", isEqualTo: startTime).where("occupied", isEqualTo: false);

    var geoFirePoint = GeoFirePoint(supplierCoordinates.latitude, supplierCoordinates.longitude);

    return (await geoFirestore
            .collection(collectionRef: query)
            .within(
              center: geoFirePoint,
              radius: MapsConfig.DRIVER_RADIUS,
              field: "geohashPoint",
            )
            .first)
        .map(ShiftModel.fromFirebase)
        .toList();
  }

  Future<String> chooseDriver(Timestamp startTime, String supplierId, GeoPoint supplierCoordinates) async {
    var query = shiftCollection.where("startTime", isEqualTo: startTime).where("occupied", isEqualTo: false);
    var geoFirePoint = GeoFirePoint(supplierCoordinates.latitude, supplierCoordinates.longitude);
    var shiftDocuments = await geoFirestore
        .collection(collectionRef: query)
        .within(
          center: geoFirePoint,
          radius: MapsConfig.DRIVER_RADIUS,
          field: "geohashPoint",
        )
        .first;

    // Ordina i documenti in base alla valutazione del fattorino
    shiftDocuments.sort((d1, d2) {
      if (d1.data["rating"] > d2.data["rating"]) return -1;
      return 1;
    });

    String driverId;
    for (var document in shiftDocuments) {
      await Firestore.instance.runTransaction((Transaction tx) async {
        final snapshot = await tx.get(document.reference);
        if (!snapshot.exists) return;
        var reservation = ShiftModel.fromFirebase(snapshot);
        if (reservation.occupied != true) {
          tx.update(document.reference, {
            'occupied': true,
          });
          driverId = reservation.driverId;
        }
      });
      if (driverId != null) break;
    }
    return driverId;
  }

  Stream<List<ShiftModel>> getReservedShiftsStream(String driverId, Timestamp startTime) {
    return shiftCollection
        .where('driverId', isEqualTo: driverId)
        .where("startTime", isGreaterThanOrEqualTo: startTime)
        .orderBy("startTime")
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, ShiftModel.fromFirebase));
  }

  Future addShift(String driverId, ShiftModel shift) async {
    await shiftCollection.document(driverId + shift.startTime.millisecondsSinceEpoch.toString()).setData({
      ...shift.toJson(),
    });
  }

  Future removeShiftByStartTime(String driverId, DateTime startTime) async {
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).delete();
  }
}
