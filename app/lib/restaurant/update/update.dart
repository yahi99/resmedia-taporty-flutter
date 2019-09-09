import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mobile_app/main.dart';

class UpdateState {
  static const MethodChannel _channel = const MethodChannel('update');

  /// opens the stripe dialog to add a new card
  /// if the source has been successfully added the card token will be returned
  static Future<String> updateState() async {
    setPublishableKey(STRIPE_PUBLIC_KEY);
    final String token = await _channel.invokeMethod('updateState');
    return token;
  }

  static bool _publishableKeySet = false;

  static bool get ready => _publishableKeySet;

  /// set the publishable key that stripe should use
  /// call this once and before you use [addSource]
  static void setPublishableKey(String apiKey) {
    _channel.invokeMethod('setPublishableKey', apiKey);
    _publishableKeySet = true;
  }
}
