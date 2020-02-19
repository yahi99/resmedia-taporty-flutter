import 'dart:async';

import 'package:dash/dash.dart';
import 'package:meta/meta.dart';
import 'package:random_string/random_string.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stripe_payment/stripe_payment.dart';

class OrderBloc implements Bloc {
  final _db = DatabaseService();
  final FunctionService _functions = FunctionService();

  @protected
  dispose() {
    _orderIdController.close();
    _orderController.close();
  }

  BehaviorSubject<String> _orderIdController;

  BehaviorSubject<OrderModel> _orderController;
  OrderModel get order => _orderController.value;
  Stream<OrderModel> get outOrder => _orderController?.stream;

  setOrderStream(String orderId) {
    _orderIdController.value = orderId;
  }

  void clear() {
    _orderIdController.value = null;
  }

  OrderBloc.instance() {
    _orderIdController = BehaviorSubject.seeded(null);
    _orderController = BehaviorController.catchStream<OrderModel>(source: _orderIdController.switchMap((orderId) {
      if (orderId == null) return Stream.value(null);
      return _db.getOrderStream(orderId);
    }));
  }

  // Crea il nuovo PaymentIntent a partire da quello vecchio
  Future<String> _processPayment(double amount, String orderId) async {
    var result = await _functions.createPaymentIntentFromPrevious(order.paymentIntentId, amount, orderId);
    var confirmPaymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
      clientSecret: result.clientSecret,
      paymentMethodId: result.paymentMethodId,
    ));
    if (confirmPaymentResult.status != 'requires_capture') throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    return confirmPaymentResult.paymentIntentId;
  }

  Future modifyOrder(List<OrderProductModel> orderProducts) async {
    if (order.state != OrderState.NEW) throw new InvalidOrderStateException("Invalid order state!");
    String orderId = randomNumeric(10);
    // Crea un nuovo PaymentIntent (quello vecchio verrà annullato dalle Cloud Functions)
    String newPaymentIntentId = await _processPayment(orderProducts.fold(0, (price, product) => price + product.quantity * product.price), orderId);

    /*
      Il PaymentIntent viene creato fuori dalla Transaction (che si trova nella funzione qui sotto).
      Potrebbe quindi accadere che non venga utilizzato perchè nel frattempo l'ordine ha cambiato stato.
      In questo caso non c'è comunque alcun problema, in quanto si annullerà da solo dopo 7 giorni.
    */
    await _db.modifyOrder(orderId, order.id, orderProducts, newPaymentIntentId);
  }
}
