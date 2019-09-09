import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:mobile_app/generated/provider.dart';
import 'package:mobile_app/logic/database.dart';
import 'package:mobile_app/model/ProductModel.dart';
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
