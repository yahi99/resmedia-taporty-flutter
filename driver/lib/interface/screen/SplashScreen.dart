import 'dart:async';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/blocs/OrderBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class SplashScreen extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  var driverBloc = $Provider.of<DriverBloc>();
  StreamSubscription subscription;

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    subscription = driverBloc.outFirebaseUser.listen((user) {
      if (user == null)
        Navigator.pushReplacementNamed(context, "/login");
      else
        Navigator.pushReplacementNamed(context, "/home");
    });

    var _messagingService = CloudMessagingService();
    _messagingService.init(_onNotificationClick);
  }

  void _onNotificationClick(dynamic data) async {
    if (await driverBloc.outDriver.first == null) return;
    //if (!(await driverBloc.isStripeActivated())) return;

    if (data['type'] == 'ORDER_NOTIFICATION') {
      var orderId = data['orderId'];
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
          logoHeight: 150,
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
