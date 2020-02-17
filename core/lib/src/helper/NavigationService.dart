import 'package:flutter/material.dart';

class NavigationService {
  static NavigationService _instance;

  NavigationService.internal(this.navigatorKey);

  factory NavigationService() {
    if (_instance == null) {
      _instance = NavigationService.internal(new GlobalKey<NavigatorState>());
    }
    return _instance;
  }

  GlobalKey<NavigatorState> navigatorKey;
}
