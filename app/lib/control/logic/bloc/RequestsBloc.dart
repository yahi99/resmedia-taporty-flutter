import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:rxdart/rxdart.dart';


class RequestsBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
    if (_requestsControlArchived != null) _requestsControlArchived.close();
  }

  PublishSubject<List<ProductRequestModel>> _requestsControl;
  PublishSubject<List<ProductRequestModel>> _requestsControlArchived;

  Stream<List<ProductRequestModel>> get outRequests =>
      _requestsControl.stream;

  Stream<List<ProductRequestModel>> get outArchivedRequests =>
      _requestsControlArchived.stream;

  RequestsBloc.instance() {
    _requestsControl = PublishController.catchStream(source: _db.getRequests());
    _requestsControlArchived = PublishController.catchStream(source: _db.getArchivedRequests());
  }

  factory RequestsBloc.of() => $Provider.of<RequestsBloc>();

  static void close() => $Provider.dispose<RequestsBloc>();
}
