import 'package:cloud_functions/cloud_functions.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_core/src/models/IntentCreationResult.dart';

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

  Future<IntentCreationResult> createPaymentIntent(String paymentMethodId, double amount) async {
    var createPaymentIntent = functions.getHttpsCallable(functionName: "createPaymentIntent");
    var result = await createPaymentIntent.call(<String, dynamic>{
      "paymentMethodId": paymentMethodId,
      "amount": amount,
    });

    IntentCreationResult parsedResult = IntentCreationResult.fromJson(result.data);

    if (parsedResult.success == false) {
      throw new PaymentIntentException(parsedResult.error);
    }

    return parsedResult;
  }
}
