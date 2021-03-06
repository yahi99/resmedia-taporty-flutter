/*import 'package:dash/dash.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class StripeBloc extends Bloc {
  DatabaseService _db = DatabaseService();
  FunctionService _functions = FunctionService();
  DriverBloc _driverBloc = $Provider.of<DriverBloc>();

  BehaviorSubject<bool> _linkCreationLoading;
  Stream<bool> get outLinkCreationLoading => _linkCreationLoading.stream;

  @override
  dispose() {
    _linkCreationLoading.close();
  }

  StripeBloc.instance() {
    _linkCreationLoading = BehaviorSubject.seeded(false);
  }

  /*Future<void> initStripeActivation() async {
    var uuid = new Uuid(options: {'grng': UuidUtil.cryptoRNG});

    var token = uuid.v4();
    await _db.setStripeActivationToken(_driverBloc.firebaseUser.uid, token);

    var stripeUrl = "https://connect.stripe.com/express/oauth/authorize?client_id=${StripeConfig.STRIPE_CLIENT_ID}&state=$token&" +
        "redirect_uri=https://us-central1-taporty-779ff.cloudfunctions.net/confirmDriverStripeAccount";
    await launch(stripeUrl);
  }*/

  Future<void> openStripeConsole() async {
    _linkCreationLoading.value = true;
    var result = await _functions.createDriverLoginLink(_driverBloc.firebaseUser.uid);
    await launch(result.link);
    _linkCreationLoading.value = false;
  }
}*/
