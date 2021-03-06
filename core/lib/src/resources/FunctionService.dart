import 'package:cloud_functions/cloud_functions.dart';
import 'package:resmedia_taporty_core/src/exceptions/PaymentIntentException.dart';
import 'package:resmedia_taporty_core/src/exceptions/StripeLinkException.dart';
import 'package:resmedia_taporty_core/src/models/IntentCreationResult.dart';
import 'package:resmedia_taporty_core/src/models/StripeLinkCreationResult.dart';

class FunctionService {
  static FunctionService _instance;

  FunctionService.internal(this.functions);

  factory FunctionService() {
    if (_instance == null) {
      var functions = CloudFunctions.instance;
      _instance = FunctionService.internal(functions);
    }
    return _instance;
  }

  final CloudFunctions functions;

  Future<IntentCreationResult> createPaymentIntent(String paymentMethodId, double amount, String orderId) async {
    var createPaymentIntent = functions.getHttpsCallable(functionName: "createPaymentIntent");
    var result = await createPaymentIntent(<String, dynamic>{
      "paymentMethodId": paymentMethodId,
      "amount": amount,
      "orderId": orderId,
    });

    IntentCreationResult parsedResult = IntentCreationResult.fromJson(result.data);

    if (parsedResult.success == false) {
      throw new PaymentIntentException(parsedResult.error);
    }

    return parsedResult;
  }

  Future<IntentCreationResult> createPaymentIntentFromPrevious(String prevPaymentIntentId, double amount, String orderId) async {
    var createPaymentIntentFromPrevious = functions.getHttpsCallable(functionName: "createPaymentIntentFromPrevious");
    var result = await createPaymentIntentFromPrevious(<String, dynamic>{
      "prevPaymentIntentId": prevPaymentIntentId,
      "amount": amount,
      "orderId": orderId,
    });

    IntentCreationResult parsedResult = IntentCreationResult.fromJson(result.data);

    if (parsedResult.success == false) {
      throw new PaymentIntentException(parsedResult.error);
    }

    return parsedResult;
  }

  Future<StripeLinkCreationResult> createDriverLoginLink(String driverId) async {
    var createDriverLoginLink = functions.getHttpsCallable(functionName: "createDriverLoginLink");
    var result = await createDriverLoginLink(<String, dynamic>{
      "driverId": driverId,
    });

    var parsedResult = StripeLinkCreationResult.fromJson(result.data);
    if (parsedResult.success == false) {
      throw new StripeLinkException(parsedResult.error);
    }

    return parsedResult;
  }
}
