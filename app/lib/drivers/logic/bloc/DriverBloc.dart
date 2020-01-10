import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class DriverBloc implements Bloc {
  Database _db = Database();

  static DriverBloc instance() => DriverBloc();

  BehaviorSubject<List<ShiftModel>> _reservedShiftsFetcher;

  Observable<List<ShiftModel>> get outReservedShifts => _reservedShiftsFetcher.stream;

  @protected
  @override
  void dispose() {
    _reservedShiftsFetcher.close();
  }

  Future setDriverStream() async {
    final user = UserBloc.of();
    final restUser = await user.outFirebaseUser.first;
    _reservedShiftsFetcher = BehaviorController.catchStream(source: _db.getReservedShiftsStream(restUser.uid));
  }

  static DriverBloc of() => $Provider.of<DriverBloc>();

  void close() => $Provider.dispose<DriverBloc>();
}
