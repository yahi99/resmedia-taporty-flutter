import 'dart:async';

import 'package:dash/dash.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

import 'DriverBloc.dart';

class CalendarBloc extends Bloc {
  final _db = DatabaseService();
  final _driverBloc = $Provider.of<DriverBloc>();

  @override
  dispose() {
    _selectedDateController.close();
    _availableStartTimesController.close();
    _dateRangeController.close();
    _dateRangeSub.cancel();
  }

  BehaviorSubject<List<DateTime>> _dateRangeController;
  Stream<List<DateTime>> get outDateRange => _dateRangeController.stream;

  BehaviorSubject<DateTime> _selectedDateController;
  Stream<DateTime> get outSelectedDate => _selectedDateController.stream;

  BehaviorSubject<List<DateTime>> _availableStartTimesController;

  // Mostra solamente i turni inclusi nella giornata selezionata.
  Stream<List<DateTime>> get outAvailableStartTimes => _availableStartTimesController.stream;

  StreamSubscription _dateRangeSub;

  CalendarBloc.instance() {
    _selectedDateController = BehaviorSubject.seeded(DateTimeHelper.getDay(DateTime.now()));
    _dateRangeController = BehaviorSubject();

    _dateRangeSub = customStreamPeriodic(Duration(minutes: 30)).listen((_) {
      DateTime now = DateTimeHelper.getDay(DateTime.now());
      List<DateTime> range = List<DateTime>();
      range.add(now);
      range.add(now.add(Duration(days: 28)));
      _dateRangeController.value = range;
    });

    _availableStartTimesController = BehaviorController.catchStream(source: outSelectedDate.asyncMap<List<DateTime>>((_selectedDate) async {
      var driver = _driverBloc.driver;
      var suppliers = await _db.getSupplierListByDriverCoordinates(driver.geohashPoint.geopoint);
      // Usa un set per rappresentare i turni prenotabili in modo da non avere doppioni
      var availableShiftSet = Set<DateTime>();
      for (var supplier in suppliers) {
        availableShiftSet.addAll(supplier.getShiftStartTimes(_selectedDate));
      }

      // Restituisci solamente i turni nel futuro
      return availableShiftSet.where((s) => s.isAfter(DateTime.now())).toList();
    }));
  }

  void setSelectedDate(DateTime date) {
    _selectedDateController.value = date;
  }

  Future addShift(DateTime startTime) async {
    var driver = _driverBloc.driver;
    var shift = ShiftModel(
      startTime: startTime,
      endTime: startTime.add(Duration(minutes: 15)),
      geohashPoint: driver.geohashPoint,
      driverId: driver.id,
      rating: driver.rating,
      occupied: false,
    );
    await _db.addShift(driver.id, shift);
  }

  Future removeShift(DateTime startTime) async {
    var driver = _driverBloc.driver;
    await _db.removeShiftByStartTime(driver.id, startTime);
  }
}
