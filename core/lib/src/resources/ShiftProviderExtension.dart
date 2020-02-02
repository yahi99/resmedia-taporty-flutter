import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_core/src/helper/DateTimeSerialization.dart';
import 'package:resmedia_taporty_core/src/helper/DistanceHelper.dart';
import 'package:resmedia_taporty_core/src/models/SupplierModel.dart';
import 'package:resmedia_taporty_core/src/models/ShiftModel.dart';
import 'package:resmedia_taporty_core/src/models/base/FirebaseModel.dart';
import 'package:resmedia_taporty_core/src/resources/DatabaseService.dart';
import 'package:resmedia_taporty_core/src/resources/SupplierProviderExtension.dart';
import 'package:resmedia_taporty_core/src/resources/DriverProviderExtension.dart';

extension ShiftProvider on DatabaseService {
  // TODO: Sposta la logica in un Bloc
  Future<List<ShiftModel>> getAvailableShifts(DateTime day, String supplierId, GeoPoint customerCoordinates) async {
    /*SupplierModel supplier = await getSupplierStream(supplierId).first;
    var startTimes = supplier.getStartTimes(day);
    var filteredShifts = List<ShiftModel>();

    for (var startTime in startTimes) {
      // Non mostrare turni nel passato o più di 48 ore nel futuro
      if (startTime.compareTo(DateTime.now()) < 30 * 60 * 1000 || startTime.difference(DateTime.now()).inMilliseconds > 48 * 60 * 60 * 1000) continue;

      var reservedShifts = (await shiftCollection.where("startTime", isEqualTo: datetimeToJson(startTime)).orderBy("reservationTimestamp").getDocuments(source: Source.server))
          .documents
          .map(ShiftModel.fromFirebase)
          .toList();

      for (var reservedShift in reservedShifts) {
        if (reservedShift.occupied != true) {
          filteredShifts.add(reservedShift);
          break;
        }
      }
    }

    return filteredShifts;*/
    await Future.delayed(Duration(seconds: 1));
    return [
      ShiftModel.fromFirebase(await shiftCollection.document("ZdDsMjleDwgacI8idqNFfeD6qDw21579171500000").get()),
    ];
  }

  // TODO: Sposta la logica in un Bloc
  Future<String> findDriver(ShiftModel shiftModel, String supplierId, GeoPoint customerCoordinates) async {
    SupplierModel supplier = await getSupplierStream(supplierId).first;
    if (!supplier.isOpen(datetime: shiftModel.endTime)) return null;

    var shiftDocuments = (await shiftCollection.where("startTime", isEqualTo: datetimeToJson(shiftModel.startTime)).orderBy("reservationTimestamp").getDocuments(source: Source.server)).documents;

    String driverId;
    bool found;
    for (var document in shiftDocuments) {
      await Firestore.instance.runTransaction((Transaction tx) async {
        var reservation = ShiftModel.fromFirebase(await tx.get(document.reference));
        var distanceSupplierDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, supplier.coordinates);
        if (distanceSupplierDriver > reservation.deliveryRadius * 1000) return;
        var distanceCustomerDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, customerCoordinates);
        if (distanceCustomerDriver > reservation.deliveryRadius * 1000) return;
        if (reservation.occupied != true) {
          tx.update(document.reference, {
            'occupied': true,
          });
          found = true;
          driverId = reservation.driverId;
        }
      });
      if (found) break;
    }
    if (!found) return null;
    return driverId;
  }

  Stream<List<ShiftModel>> getReservedShiftsStream(String driverId) {
    return shiftCollection
        .where('driverId', isEqualTo: driverId)
        .where("startTime", isGreaterThanOrEqualTo: datetimeToJson(DateTimeHelper.getDay(DateTime.now())))
        .orderBy("startTime")
        .snapshots(includeMetadataChanges: true)
        .map((querySnap) => fromQuerySnaps(querySnap, ShiftModel.fromFirebase));
  }

  Future addShift(String driverId, DateTime startTime) async {
    var driver = await getDriverById(driverId);
    var shift = ShiftModel(
      startTime: startTime,
      endTime: startTime.add(Duration(minutes: 15)),
      driverCoordinates: driver.coordinates,
      driverId: driverId,
      deliveryRadius: driver.deliveryRadius,
      occupied: false,
    );
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).setData({
      ...shift.toJson(),
      "reservationTimestamp": datetimeToJson(DateTime.now()),
    });
  }

  Future removeShift(String driverId, DateTime startTime) async {
    await shiftCollection.document(driverId + startTime.millisecondsSinceEpoch.toString()).delete();
  }
}
