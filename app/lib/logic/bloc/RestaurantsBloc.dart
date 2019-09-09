import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/model/RestaurantModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

import '../database.dart';

class RestaurantsBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    _restaurantsControl.close();
  }

  PublishSubject<List<RestaurantModel>> _restaurantsControl;

  Stream<List<RestaurantModel>> get outRestaurants =>
      _restaurantsControl.stream;

  RestaurantsBloc.instance() {
    //_restaurantsControl = PublishController.catchStream(source: _db.getRestaurants());
    //_restaurantsControl.listen(print);
    _restaurantsControl =
        PublishController.catchStream(source: _db.getRestaurants());
  }

  void getTypeStream(String type) {
    _restaurantsControl =
        PublishController.catchStream(source: _db.getTypeRestaurants(type));
  }

  factory RestaurantsBloc.of() => $Provider.of<RestaurantsBloc>();

  static void close() => $Provider.dispose<RestaurantsBloc>();
}
