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

  Stream<String> get onTokenRefresh => _messaging.onTokenRefresh;

  Future init(Function(dynamic data) callback) async {
    if (Platform.isIOS) await iOSPermission();

    _messaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print(message);
        var data = message['data'] ?? message;
        var notification = message['notification'] ?? message['aps']['alert'] ?? null;
        if (notification != null)
          showOverlayNotification((context) {
            return ForegroundNotification(
              notification['title'],
              notification['body'],
              onTap: () {
                OverlaySupportEntry.of(context).dismiss();
                callback(data);
              },
            );
          });
      },
      onResume: (Map<String, dynamic> message) async {
        var data = message['data'] ?? message;
        callback(data);
      },
    );
  }

  Future iOSPermission() async {
    await _messaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
  }
}
