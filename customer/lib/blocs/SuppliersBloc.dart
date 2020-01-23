import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class SuppliersBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _suppliersControl.close();
    _availableStartTimesFetcher.close();
  }

  PublishSubject<List<SupplierModel>> _suppliersControl;

  Stream<List<SupplierModel>> get outSuppliers => _suppliersControl.stream;

  PublishSubject<List<DateTime>> _availableStartTimesFetcher;

  Stream<List<DateTime>> get outAvailableStartTimes => _availableStartTimesFetcher.stream;

  SuppliersBloc.instance() {
    _suppliersControl = PublishController.catchStream(source: _db.getSupplierListStream());
    _availableStartTimesFetcher = PublishSubject();
  }

  fetchAvailableStartTimes(DateTime date, String driverId) async {
    var driver = await _db.getUserById(driverId);
    var suppliers = await _db.getSupplierList();
    var filteredSuppliers = List<SupplierModel>();
    for (var supplier in suppliers) {
      if ((await DistanceHelper.fetchAproximateDistance(supplier.coordinates, driver.coordinates)) <= driver.deliveryRadius * 1000) filteredSuppliers.add(supplier);
    }

    var supplierStartTimes = filteredSuppliers.map((supplier) => supplier.getStartTimes(date));

    var currentDate = DateTimeHelper.getDay(date);
    var endDate = currentDate.add(Duration(days: 1));

    var availableShifts = List<DateTime>();
    while (currentDate != endDate) {
      for (var startTimes in supplierStartTimes) {
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
}
