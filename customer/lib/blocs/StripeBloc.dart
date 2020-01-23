import 'dart:async';

import 'package:dash/dash.dart';
import 'package:easy_stripe/easy_stripe.dart';
import 'package:flutter/foundation.dart';

class StripeBloc implements Bloc {
  @protected
  dispose() {
    _sourceController.close();
  }

  StreamController<StripeSourceModel> _sourceController;

  Stream<StripeSourceModel> get outSource => _sourceController.stream;
}
