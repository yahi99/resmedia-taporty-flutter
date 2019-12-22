import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';


class ControlBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
  }

  PublishSubject<List<UserModel>> _requestsControl;

  Stream<List<UserModel>> get outRequests =>
      _requestsControl.stream;

  ControlBloc.instance() {
    _requestsControl = PublishController.catchStream(source: _db.getAdminsControl());
  }

  factory ControlBloc.of() => $Provider.of<ControlBloc>();

  static void close() => $Provider.dispose<ControlBloc>();
}
