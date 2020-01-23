import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class DriverBloc implements Bloc {
  Database _db = Database();

  static DriverBloc instance() => DriverBloc();

  BehaviorSubject<List<ShiftModel>> _reservedShiftsFetcher;

  Stream<List<ShiftModel>> get outReservedShifts => _reservedShiftsFetcher.stream;

  @protected
  @override
  void dispose() {
    _reservedShiftsFetcher.close();
  }

  Future setDriverStream(String driverId) async {
    _reservedShiftsFetcher = BehaviorController.catchStream(source: _db.getReservedShiftsStream(driverId));
  }
}