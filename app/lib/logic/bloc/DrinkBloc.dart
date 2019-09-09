import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/ProductModel.dart';

class DrinkBloc implements Bloc {
  DrinkBloc.instance();

  void initPathDrink(String path) async {
    _drinkModelControl.add(await Database().getDrink(path));
  }

  @protected
  dispose() {
    _drinkModelControl.close();
  }

  final CacheSubject<DrinkModel> _drinkModelControl = CacheSubject();

  CacheObservable<DrinkModel> get outDrink => _drinkModelControl.stream;

  static DrinkBloc of() => $Provider.of<DrinkBloc>();

  void close() => $Provider.dispose<DrinkBloc>();
}
