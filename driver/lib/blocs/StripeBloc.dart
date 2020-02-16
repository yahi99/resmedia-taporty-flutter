import 'package:dash/dash.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';
import 'package:uuid/uuid_util.dart';

class StripeBloc extends Bloc {
  DatabaseService _db = DatabaseService();
  DriverBloc _driverBloc = $Provider.of<DriverBloc>();

  @override
  dispose() {}

  StripeBloc.instance();

  Future<void> initStripeActivation() async {
    var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});

    var token = uuid.v4();
    await _db.setStripeActivationToken(_driverBloc.firebaseUser.uid, token);

    var stripeUrl = "https://connect.stripe.com/express/oauth/authorize?client_id=${StripeConfig.STRIPE_CLIENT_ID}&state=$token&" +
        "redirect_uri=https://us-central1-taporty-779ff.cloudfunctions.net/confirmDriverStripeAccount";
    await launch(stripeUrl);
  }
}
