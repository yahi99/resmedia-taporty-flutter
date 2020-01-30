import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class ShiftBloc extends Bloc {
  DatabaseService _db = DatabaseService();

  BehaviorSubject<List<ShiftModel>> _reservedShiftsController;

  Stream<List<ShiftModel>> get outReservedShifts => _reservedShiftsController.stream;

  @override
  dispose() {
    _reservedShiftsController.close();
  }

  ShiftBloc.instance() {
    var driverBloc = $Provider.of<DriverBloc>();
    _reservedShiftsController = BehaviorController.catchStream<List<ShiftModel>>(source: driverBloc.outDriver.switchMap((driver) {
      if (driver?.id == null) return Stream.value(null);
      return _db.getReservedShiftsStream(driver.id);
    }));
  }
}
