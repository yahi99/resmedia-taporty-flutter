import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/helper/DateTimeHelper.dart';
import 'package:resmedia_taporty_flutter/common/helper/DistanceHelper.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/model/RestaurantModel.dart';
import 'package:rxdart/rxdart.dart';

class RestaurantsBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantsControl.close();
    _availableStartTimesFetcher.close();
  }

  PublishSubject<List<RestaurantModel>> _restaurantsControl;

  Stream<List<RestaurantModel>> get outRestaurants => _restaurantsControl.stream;

  PublishSubject<List<DateTime>> _availableStartTimesFetcher;

  Observable<List<DateTime>> get outAvailableStartTimes => _availableStartTimesFetcher.stream;

  RestaurantsBloc.instance() {
    _restaurantsControl = PublishController.catchStream(source: _db.getRestaurantListStream());
    _availableStartTimesFetcher = PublishSubject();
  }

  fetchAvailableStartTimes(DateTime date, String driverId) async {
    var driver = await _db.getUserById(driverId);
    var restaurants = await _db.getRestaurantList();
    var filteredRestaurants = List<RestaurantModel>();
    for (var restaurant in restaurants) {
      if ((await DistanceHelper.fetchAproximateDistance(restaurant.coordinates, driver.coordinates)) <= driver.deliveryRadius) filteredRestaurants.add(restaurant);
    }

    var restaurantStartTimes = filteredRestaurants.map((restaurant) => restaurant.getStartTimes(date));

    var currentDate = DateTimeHelper.getDay(date);
    var endDate = currentDate.add(Duration(days: 1));

    var availableShifts = List<DateTime>();
    while (currentDate != endDate) {
      for (var startTimes in restaurantStartTimes) {
        var foundStartTime = startTimes.firstWhere((startTime) => startTime == currentDate, orElse: () => null);
        if (foundStartTime != null) {
          availableShifts.add(foundStartTime);
          break;
        }
      }

      currentDate = currentDate.add(Duration(minutes: 15));
    }

    _availableStartTimesFetcher.sink.add(availableShifts);
  }

  factory RestaurantsBloc.of() => $Provider.of<RestaurantsBloc>();

  static void close() => $Provider.dispose<RestaurantsBloc>();
}
