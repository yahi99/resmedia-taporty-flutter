import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/control/model/DriverRequestModel.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:rxdart/rxdart.dart';

import 'RequestsBloc.dart';

class DriverRequestsBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
    if (_requestsArchiveControl != null) _requestsArchiveControl.close();
  }

  PublishSubject<List<DriverRequestModel>> _requestsControl;
  PublishSubject<List<DriverRequestModel>> _requestsArchiveControl;

  Stream<List<DriverRequestModel>> get outRequests =>
      _requestsControl.stream;

  Stream<List<DriverRequestModel>> get outArchivedRequests =>
      _requestsControl.stream;

  DriverRequestsBloc.instance() {
    _requestsControl = PublishController.catchStream(source: _db.getDriverRequests());
    _requestsArchiveControl = PublishController.catchStream(source: _db.getArchivedDriverRequests());
  }

  factory DriverRequestsBloc.of() => $Provider.of<DriverRequestsBloc>();

  static void close() => $Provider.dispose<RequestsBloc>();
}
