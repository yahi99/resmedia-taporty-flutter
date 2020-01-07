import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/common/model/ShiftModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/resources/Database.dart';
import 'package:rxdart/rxdart.dart';

class TimeBloc implements Bloc {
  final _db = Database();

  static TimeBloc instance() => TimeBloc();

  @protected
  @override
  void dispose() {
    _outControl.close();
  }

  PublishSubject<List<ShiftModel>> _outControl;

  Stream<List<ShiftModel>> get outTurns => _outControl.stream;

  void setDay(DateTime day) async {
    _outControl = PublishController.catchStream(source: _db.getUsersTurn(day.toIso8601String()));
    _outControl.listen(print);
  }

  static TimeBloc of() => $Provider.of<TimeBloc>();

  void close() => $Provider.dispose<TimeBloc>();
}
