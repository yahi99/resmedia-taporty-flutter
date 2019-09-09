import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/TypesRestaurantModel.dart';
import 'package:rxdart/rxdart.dart';

class TypesRestaurantBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantsControl.close();
  }

  PublishSubject<List<TypesRestaurantModel>> _restaurantsControl;

  Stream<List<TypesRestaurantModel>> get outRestaurants =>
      _restaurantsControl.stream;

  TypesRestaurantBloc.instance() {
    _restaurantsControl =
        PublishController.catchStream(source: _db.getTypesRestaurants());
    _restaurantsControl.listen(print);
  }

  factory TypesRestaurantBloc.of() => $Provider.of<TypesRestaurantBloc>();

  static void close() => $Provider.dispose<TypesRestaurantBloc>();
}
