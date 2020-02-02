import 'dart:async';

import 'package:dash/dash.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';

class StripeBloc implements Bloc {
  @protected
  dispose() {
    _sourceController.close();
  }

  BehaviorSubject<StripeSourceModel> _sourceController;

  Stream<StripeSourceModel> get outSource => _sourceController.stream;
  StripeSourceModel get source => _sourceController.value;

  StripeBloc.instance();
}
