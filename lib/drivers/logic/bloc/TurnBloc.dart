import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:meta/meta.dart';
import 'package:dash/dash.dart';
import 'package:mobile_app/drivers/model/TurnModel.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/logic/bloc/UserBloc.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:rxdart/rxdart.dart';


class TurnBloc implements Bloc {

  final _db = Database();

  @protected
  static TurnBloc instance() => TurnBloc();

  @protected
  @override
  void dispose() {
    _turnControl.close();
  }

  PublishSubject<List<TurnModel>> _turnControl;
  Stream<List<TurnModel>> get outTurns => _turnControl.stream;

  Stream<Map<MonthCategory, List<TurnModel>>> get outCategorizedTurns => outTurns.map((models) {
    return categorized(MonthCategory.values, models, (model) => model.month);
  });

  void setTurnStream() async{
    final user=UserBloc.of();
    final restUser=await user.outFirebaseUser.first;
    //final str=await _db.getDriverOrders(restUser.uid).first;
    print('lol');
    _turnControl = PublishController.catchStream(source: _db.getTurns(restUser.uid));
    _turnControl.listen(print);
  }

  static TurnBloc of() => $Provider.of<TurnBloc>();
  void close() => $Provider.dispose<TurnBloc>();
}
