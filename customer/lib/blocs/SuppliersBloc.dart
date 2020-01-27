import 'package:dash/dash.dart';
import 'package:easy_blocs/easy_blocs.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class SuppliersBloc implements Bloc {
  final _db = DatabaseService();

  @protected
  dispose() {
    _suppliersControl.close();
  }

  PublishSubject<List<SupplierModel>> _suppliersControl;

  Stream<List<SupplierModel>> get outSuppliers => _suppliersControl.stream;

  SuppliersBloc.instance() {
    _suppliersControl = PublishController.catchStream(source: _db.getSupplierListStream());
  }
}
