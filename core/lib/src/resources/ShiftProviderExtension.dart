import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_core/src/models/DriverReservationModel.dart';
import 'package:resmedia_taporty_core/src/models/SupplierModel.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';
import 'package:resmedia_taporty_core/src/resources/SupplierProviderExtension.dart';
import 'package:resmedia_taporty_core/src/resources/DriverProviderExtension.dart';

extension ShiftProvider on DatabaseService {
  // Restituisce la lista di ShiftModel in cui vi sono fattorini ancora disponibili
  Future<List<ShiftModel>> getAvailableShifts(DateTime day, String areaId, Timestamp startTime, Timestamp endTime) async {
    return (await areaCollection
            .document(areaId)
            .collection(Collections.DAYS)
            .document(DateTimeHelper.getIso8601DateString(day))
            .collection(Collections.SHIFTS)
            .where('availableDrivers', isGreaterThan: 0)
            .where("startTime", isGreaterThan: startTime)
            .where('startTime', isLessThan: endTime)
            .orderBy('startTime')
            .getDocuments(source: Source.server))
        .documents
        .map(ShiftModel.fromFirebase)
        .toList();
  }

  Future<String> chooseDriver(String areaId, DateTime day, DateTime startTime, GeoPoint customerCoordinates, GeoPoint supplierCoordinates) async {
    var shiftDocument = areaCollection
        .document(areaId)
        .collection(Collections.DAYS)
        .document(DateTimeHelper.getIso8601DateString(day))
        .collection(Collections.SHIFTS)
        .document(DateTimeHelper.getTimeString(startTime));

    String driverId;

    await Firestore.instance.runTransaction((Transaction tx) async {
      var shift = ShiftModel.fromFirebase(await tx.get(shiftDocument));
      // Ottiene i fattorini ancora disponibili
      var reservations = shift.driverReservations.values.where((res) => res.available).toList();

      if (reservations.length == 0) return;

      // Calcola la somma delle distanze del fattorino dalla posizione scelta dall'utente e da quella del fornitore
      for (var res in reservations) {
        var customerDistance = await DistanceHelper.fetchAproximateDistance(res.geopoint, customerCoordinates);
        var supplierDistance = await DistanceHelper.fetchAproximateDistance(res.geopoint, supplierCoordinates);
        res.totalDistance = customerDistance + supplierDistance;
      }

      /*
        Seleziona il fattorino ordinandolo in base a:
        - somma delle distanze del fattorino dalla posizione scelta dall'utente e da quella del fornitore (approssimazione al kilometro)
        - valutazione del fattorino
      */
      var selectedReservation = reservations.reduce((resA, resB) {
        if ((resA.totalDistance - resB.totalDistance) / 1000.0 >= 1.0) return resB;
        if ((resB.totalDistance - resA.totalDistance) / 1000.0 >= 1.0) return resA;
        if (resA.rating > resB.rating) return resA;
        return resB;
      });

      selectedReservation.available = false;

      tx.update(shiftDocument, {
        'driverReservations': shift.driverReservations,
      });

      driverId = selectedReservation.driverId;
    });

    return driverId;
  }

  Stream<List<ShiftModel>> getReservedShiftsStream(String driverId, Timestamp timestamp) {
    return shiftCollectionGroup
        .where('reservedDrivers.$driverId.driverId', isEqualTo: driverId)
        .where("startTime", isGreaterThanOrEqualTo: timestamp)
        .orderBy("startTime")
        .snapshots()
        .map((querySnap) => fromQuerySnaps(querySnap, ShiftModel.fromFirebase));
  }

  Future addShift(String driverId, String areaId, DateTime day, DateTime startTime, GeoPoint geopoint, double rating) async {
    var shiftRef = areaCollection
        .document(areaId)
        .collection(Collections.DAYS)
        .document(DateTimeHelper.getIso8601DateString(day))
        .collection(Collections.SHIFTS)
        .document(DateTimeHelper.getTimeString(startTime));

    DriverReservationModel reservationModel = new DriverReservationModel(driverId, true, geopoint, rating);

    // TODO: Verificare che funzioni (vedi se spostare dal map ad una sottocollezione)
    await shiftRef.updateData({
      "reservedDrivers": {
        driverId: reservationModel.toJson(),
      },
    });
  }

  Future removeShift(String driverId, String areaId, DateTime day, DateTime startTime) async {
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).delete();
  }
}
