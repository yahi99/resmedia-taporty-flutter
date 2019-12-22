import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_flutter/generated/provider.dart';
import 'package:resmedia_taporty_flutter/common/logic/database.dart';
import 'package:resmedia_taporty_flutter/common/model/ProductModel.dart';
import 'package:rxdart/rxdart.dart';


class ProductBloc implements Bloc {
  final _db = Database();

  @protected
  dispose() {
    if (_requestsControl != null) _requestsControl.close();
  }

  PublishSubject<FoodModel> _requestsControl;

  Stream<FoodModel> get outRequests =>
      _requestsControl.stream;

  ProductBloc.instance();

  factory ProductBloc.init({@required ProductModel model}) {
    final bc = ProductBloc.of();
    bc._requestsControl = PublishController.catchStream(source: bc._db.getProduct(model));
    return bc;
  }

  factory ProductBloc.of() => $Provider.of<ProductBloc>();

  static void close() => $Provider.dispose<ProductBloc>();
}
