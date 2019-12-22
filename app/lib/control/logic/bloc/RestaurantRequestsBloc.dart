import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/control/model/RestaurantRequestModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:rxdart/rxdart.dart';

import 'RequestsBloc.dart';

class RestaurantRequestsBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
    if (_requestsArchivedControl != null) _requestsArchivedControl.close();
  }

  PublishSubject<List<RestaurantRequestModel>> _requestsControl;
  PublishSubject<List<RestaurantRequestModel>> _requestsArchivedControl;

  Stream<List<RestaurantRequestModel>> get outRequests =>
      _requestsControl.stream;

  Stream<List<RestaurantRequestModel>> get outArchivedRequests =>
      _requestsArchivedControl.stream;

  RestaurantRequestsBloc.instance() {
    _requestsControl = PublishController.catchStream(source: _db.getRestaurantRequests());
    _requestsArchivedControl = PublishController.catchStream(source: _db.getArchivedRestaurantRequests());
  }

  factory RestaurantRequestsBloc.of() => $Provider.of<RestaurantRequestsBloc>();

  static void close() => $Provider.dispose<RequestsBloc>();
}
