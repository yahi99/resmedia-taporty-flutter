import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_customer/blocs/UserBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var userBloc = $Provider.of<UserBloc>();
  StreamSubscription subscription;

  BuildContext _context;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _context = context;
    subscription = userBloc.outFirebaseUser.listen((user) {
      if (user == null)
        Navigator.pushReplacementNamed(context, "/login");
      else
        Navigator.pushReplacementNamed(context, "/geolocalization");
    });

    var _messagingService = CloudMessagingService();
    _messagingService.init(_onNotificationClick);
  }

  void _onNotificationClick(Map<String, dynamic> message) async {
    if (await userBloc.outUser.first == null) return;

    if (message['data']['type'] == 'ORDER_NOTIFICATION') {
      var orderId = message['data']['orderId'];
      if (orderId == null) return;

      $Provider.of<OrderBloc>().setOrderStream(orderId);

      await NavigationService().navigatorKey.currentState.pushNamed("/orderDetail");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Theme(
        child: LogoView(
          logoHeight: 200,
          children: [
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
