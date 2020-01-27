import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class ShiftBloc extends Bloc {
  DatabaseService _db = DatabaseService();

  BehaviorSubject<List<ShiftModel>> _reservedShiftsController;

  Stream<List<ShiftModel>> get outReservedShifts => _reservedShiftsController.stream;

  @override
  dispose() {
    _reservedShiftsController.close();
  }

  Future setDriverStream(String driverId) async {
    _reservedShiftsController = BehaviorController.catchStream(source: _db.getReservedShiftsStream(driverId));
  }
}
