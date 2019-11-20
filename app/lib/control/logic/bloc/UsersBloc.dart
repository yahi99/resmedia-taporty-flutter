import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/control/model/ProductRequestModel.dart';
import 'package:resmedia_taporty_flutter/drivers/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/logic/bloc/UserBloc.dart';
import 'package:resmedia_taporty_flutter/logic/database.dart';
import 'package:resmedia_taporty_flutter/model/OrderModel.dart';
import 'package:resmedia_taporty_flutter/model/UserModel.dart';
import 'package:rxdart/rxdart.dart';

import 'RequestsBloc.dart';

class UsersBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
    if (_requestsControlUsers != null) _requestsControlUsers.close();
  }

  PublishSubject<List<UserModel>> _requestsControl;
  PublishSubject<List<UserModel>> _requestsControlUsers;

  Stream<List<UserModel>> get outRequests =>
      _requestsControl.stream;

  Stream<List<UserModel>> get outRequestsUsers =>
      _requestsControlUsers.stream;

  UsersBloc.instance() {
    _requestsControl = PublishController.catchStream(source: _db.getUsersControl());
    _requestsControlUsers = PublishController.catchStream(source: _db.getUsersMod());
  }

  factory UsersBloc.of() => $Provider.of<UsersBloc>();

  static void close() => $Provider.dispose<UsersBloc>();
}
