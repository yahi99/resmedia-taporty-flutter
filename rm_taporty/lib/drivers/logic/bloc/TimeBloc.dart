import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:dash/dash.dart';
import 'package:mobile_app/drivers/model/ShiftModel.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:rxdart/rxdart.dart';


class TimeBloc implements Bloc {

  final _db = Database();

  @protected
  static TimeBloc instance() => TimeBloc();

  @protected
  @override
  void dispose() {
    _outControl.close();
  }

  PublishSubject<List<ShiftModel>> _outControl;
  Stream<List<ShiftModel>> get outTurns => _outControl.stream;

  void setDay(DateTime day) async{
    print('lol');
    _outControl = PublishController.catchStream(source: _db.getUsersTurn(day.toIso8601String()));
    _outControl.listen(print);
  }

  static TimeBloc of() => $Provider.of<TimeBloc>();
  void close() => $Provider.dispose<TimeBloc>();
}
