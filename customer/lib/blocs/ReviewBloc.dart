import 'dart:async';

import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:rxdart/rxdart.dart';

class ReviewBloc implements Bloc {
  final _db = DatabaseService();
  final _orderBloc = $Provider.of<OrderBloc>();

  @protected
  dispose() {
    _supplierReviewController.close();
    _driverReviewController.close();
    _isSupplierReviewController.close();
  }

  BehaviorSubject<bool> _isSupplierReviewController;
  bool get isSupplier => _isSupplierReviewController.value;
  Stream<bool> get outIsSupplier => _isSupplierReviewController.stream;

  BehaviorSubject<ReviewModel> _supplierReviewController;

  Stream<ReviewModel> get outSupplierReview => _supplierReviewController.stream;

  BehaviorSubject<ReviewModel> _driverReviewController;

  Stream<ReviewModel> get outDriverReview => _driverReviewController.stream;

  Future setReview(double rating, String description) async {
    var order = _orderBloc.order;
    if (isSupplier) {
      await _db.setSupplierReview(order.supplierId, order.customerId, order.customerName, order.id, rating, description);
    } else {
      await _db.setDriverReview(order.driverId, order.customerId, order.customerName, order.id, rating, description);
    }
  }

  void setReviewType(bool isSupplier) => _isSupplierReviewController.value = isSupplier;

  ReviewBloc.instance() {
    _isSupplierReviewController = BehaviorSubject.seeded(false);
    _supplierReviewController = BehaviorController.catchStream(source: _orderBloc.outOrder.switchMap((order) {
      if (order == null) return Stream.value(null);
      return _db.getSupplierReviewStream(order.supplierId, order.id);
    }));

    _driverReviewController = BehaviorController.catchStream(source: _orderBloc.outOrder.switchMap((order) {
      if (order == null) return Stream.value(null);
      return _db.getDriverReviewStream(order.driverId, order.id);
    }));
  }
}
