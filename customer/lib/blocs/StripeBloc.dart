import 'dart:async';

import 'package:dash/dash.dart';
import 'package:flutter/foundation.dart';
import 'package:resmedia_taporty_core/core.dart';

class StripeBloc implements Bloc {
  @protected
  dispose() {
    _sourceController.close();
  }

  StreamController<StripeSourceModel> _sourceController;

  Stream<StripeSourceModel> get outSource => _sourceController.stream;

  StripeBloc.instance();
}
