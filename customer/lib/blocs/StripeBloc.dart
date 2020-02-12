import 'dart:async';

import 'package:dash/dash.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeBloc implements Bloc {
  @override
  dispose() {
    _paymentMethodController.close();
  }

  BehaviorSubject<PaymentMethod> _paymentMethodController;

  Stream<PaymentMethod> get outPaymentMethod => _paymentMethodController.stream;
  PaymentMethod get paymentMethod => _paymentMethodController.value;

  void setPaymentMethod(PaymentMethod method) {
    _paymentMethodController.value = method;
  }

  StripeBloc.instance() {
    _paymentMethodController = BehaviorSubject();
  }
}
