import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';
import 'package:resmedia_taporty_core/src/resources/DriverProviderExtension.dart';

extension ShiftProvider on DatabaseService {
  Future<List<DocumentSnapshot>> _getAvailableShiftDocuments(Timestamp startTime, GeoPoint supplierCoordinates) async {
    var query = shiftCollection.where("startTime", isEqualTo: startTime).where("occupied", isEqualTo: false).orderBy("rating", descending: true);
    var geoFirePoint = GeoFirePoint(supplierCoordinates.latitude, supplierCoordinates.longitude);
    return await geoFirestore
        .collection(collectionRef: query)
        .within(
          center: geoFirePoint,
          radius: MapsConfig.DRIVER_RADIUS,
          field: "geohashPoint",
        )
        .first;
  }

  Future<List<ShiftModel>> getAvailableShifts(Timestamp startTime, GeoPoint supplierCoordinates) async {
    return (await _getAvailableShiftDocuments(startTime, supplierCoordinates)).map(ShiftModel.fromFirebase);
  }

  Future<String> chooseDriver(Timestamp startTime, String supplierId, GeoPoint supplierCoordinates) async {
    var shiftDocuments = await _getAvailableShiftDocuments(startTime, supplierCoordinates);

    String driverId;
    for (var document in shiftDocuments) {
      await Firestore.instance.runTransaction((Transaction tx) async {
        var reservation = ShiftModel.fromFirebase(await tx.get(document.reference));
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
        .snapshots(includeMetadataChanges: true)
        .map((querySnap) => fromQuerySnaps(querySnap, ShiftModel.fromFirebase));
  }

  Future addShift(String driverId, DateTime startTime) async {
    var driver = await getDriverById(driverId);
    var shift = ShiftModel(
      startTime: startTime,
      endTime: startTime.add(Duration(minutes: 15)),
      geohashPoint: driver.geohashPoint,
      driverId: driverId,
      rating: driver.rating,
      occupied: false,
    );
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).setData({
      ...shift.toJson(),
    });
  }

  Future removeShift(String driverId, DateTime startTime) async {
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).delete();
  }
}
