import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/drivers/model/TurnModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:rxdart/rxdart.dart';

class TurnBloc implements Bloc {
  final _db = Database();

  static TurnBloc instance() => TurnBloc();

  @protected
  @override
  void dispose() {
    if(_turnControl!=null) _turnControl.close();
    if(_turnControlRest!=null) _turnControlRest.close();
  }

  PublishSubject<List<TurnModel>> _turnControl;
  PublishSubject<List<TurnModel>> _turnControlRest;

  Stream<List<TurnModel>> get outTurns => _turnControl.stream;
  Stream<List<TurnModel>> get outTurnsRest => _turnControlRest.stream;

  Stream<Map<MonthCategory, List<TurnModel>>> get outCategorizedTurns =>
      outTurns.map((models) {
        return categorized(
            MonthCategory.values, models, (model) => model.month);
      });
  Stream<Map<MonthCategory, List<TurnModel>>> get outCategorizedTurnsRest =>
      outTurnsRest.map((models) {
        return categorized(
            MonthCategory.values, models, (model) => model.month);
      });

  void setTurnStream(String uid) async {
    //final user = UserBloc.of();
    //final restUser = await user.outFirebaseUser.first;
    //final str=await _db.getDriverOrders(restUser.uid).first;
    
    _turnControl =
        PublishController.catchStream(source: _db.getTurns(uid));
    _turnControl.listen(print);
  }
  void setTurnRestStream() async {
    final user = UserBloc.of();
    final restUser = await user.outUser.first;
    //final str=await _db.getDriverOrders(restUser.uid).first;
    
    _turnControlRest =
        PublishController.catchStream(source: _db.getTurnsRest(restUser.model.restaurantId));
    _turnControlRest.listen(print);
  }

  static TurnBloc of() => $Provider.of<TurnBloc>();

  void close() => $Provider.dispose<TurnBloc>();
}
