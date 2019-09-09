import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';

class FoodBloc implements Bloc {
  FoodBloc.instance();

  void inPathFood(String path) async {
    _foodControl.add(await Database().getFood(path));
  }

  @protected
  dispose() {
    _foodControl.close();
  }

  final BehaviorSubject<FoodModel> _foodControl = BehaviorSubject();

  Stream<FoodModel> get outFood => _foodControl.stream;

  static FoodBloc of() => $Provider.of<FoodBloc>();

  void close() => $Provider.dispose<FoodBloc>();
}
