import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:resmedia_taporty_core/src/widgets/ForegroundNotification.dart';

class CloudMessagingService {
  static CloudMessagingService _instance;

  CloudMessagingService.internal(this._messaging);

  factory CloudMessagingService() {
    if (_instance == null) {
      _instance = CloudMessagingService.internal(FirebaseMessaging());
    }
    return _instance;
  }

  final FirebaseMessaging _messaging;

  Future init(Function(Map<String, dynamic> message) callback) async {
    if (Platform.isIOS) await iOSPermission();

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        showOverlayNotification((context) {
          return ForegroundNotification(
            message['notification']['title'],
            message['notification']['body'],
            onTap: () {
              OverlaySupportEntry.of(context).dismiss();
              callback(message);
            },
          );
        });
      },
      onResume: (Map<String, dynamic> message) async {
        callback(message);
      },
    );
  }

  Future iOSPermission() async {
    await _messaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}
