import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:resmedia_taporty_flutter/common/helper/DistanceHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/DriverReservationModel.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/MixinRestaurantProvider.dart';
import 'package:resmedia_taporty_flutter/config/Collections.dart';

mixin MixinShiftProvider on MixinRestaurantProvider {
  final shiftCollection = Firestore.instance.collection(Collections.SHIFTS);

  Future<List<ShiftModel>> getAvailableShifts(DateTime day, String restaurantId, GeoPoint customerCoordinates) async {
    RestaurantModel restaurant = await getRestaurant(restaurantId);
    var shifts = restaurant.getShifts(day);
    var filteredShifts = List<ShiftModel>();

    for (var shift in shifts) {
      var driverReservations = (await shiftCollection.document(shift.id).collection(Collections.DRIVER_RESERVATIONS).orderBy("reservationTimestamp").getDocuments(source: Source.server))
          .documents
          .map(DriverReservationModel.fromFirebase)
          .toList();
      for (var reservation in driverReservations) {
        var distanceRestaurantDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, restaurant.coordinates);
        if (distanceRestaurantDriver > reservation.deliveryRadius) continue;
        var distanceCustomerDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, customerCoordinates);
        if (distanceCustomerDriver > reservation.deliveryRadius) continue;
        if (reservation.occupied != true) {
          filteredShifts.add(shift);
          break;
        }
      }
    }

    // Don't show shifts from the past and more than 48 hours in the future
    return filteredShifts.where((shift) => shift.startTime.compareTo(DateTime.now()) > 0 && shift.startTime.difference(DateTime.now()).inMilliseconds < 48 * 60 * 60 * 1000).toList();
  }

  Future<String> findDriver(ShiftModel shiftModel, String restaurantId, GeoPoint customerCoordinates) async {
    RestaurantModel restaurant = await getRestaurant(restaurantId);
    if (!restaurant.isOpen(datetime: shiftModel.endTime)) return null;

    var reservationDocuments =
        (await shiftCollection.document(shiftModel.startTime.toIso8601String()).collection(Collections.DRIVER_RESERVATIONS).orderBy("reservationTimestamp").getDocuments(source: Source.server))
            .documents;

    String driverId;
    bool found;
    for (var document in reservationDocuments) {
      await Firestore.instance.runTransaction((Transaction tx) async {
        var reservation = DriverReservationModel.fromFirebase(await tx.get(document.reference));
        var distanceRestaurantDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, restaurant.coordinates);
        if (distanceRestaurantDriver > reservation.deliveryRadius) return;
        var distanceCustomerDriver = await DistanceHelper.fetchAproximateDistance(reservation.driverCoordinates, customerCoordinates);
        if (distanceCustomerDriver > reservation.deliveryRadius) return;
        if (reservation.occupied != true) {
          tx.update(document.reference, {
            'occupied': true,
          });
          found = true;
          driverId = reservation.id;
        }
      });
      if (found) break;
    }
    if (!found) return null;
    return driverId;
  }
}
