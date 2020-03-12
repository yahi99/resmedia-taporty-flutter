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
    _confirmLoadingController.close();
  }

  BehaviorSubject<String> _orderIdController;

  BehaviorSubject<OrderModel> _orderController;
  OrderModel get order => _orderController.value;
  Stream<OrderModel> get outOrder => _orderController?.stream;

  BehaviorSubject<bool> _confirmLoadingController;
  Stream<bool> get outConfirmLoading => _confirmLoadingController.stream;

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
    _confirmLoadingController = BehaviorSubject.seeded(false);
  }

  Future<String> modifyOrder(List<OrderProductModel> orderProducts) async {
    _confirmLoadingController.value = true;
    try {
      if (order.state != OrderState.NEW) throw new InvalidOrderStateException("Invalid order state!");
      // Assegna un id a 10 cifre all'ordine
      String orderId = randomNumeric(10);

      // Calcola il totale dei prodotti e il prezzo per la spedizione
      double cartAmount = orderProducts.fold(0, (price, product) => price + product.quantity * product.price);
      double deliveryAmount = order.deliveryAmount;

      // Crea un nuovo PaymentIntent (quello vecchio verrà annullato dalle Cloud Functions)
      String newPaymentIntentId = await _processPayment(cartAmount, deliveryAmount, orderId);

      /*
        Il PaymentIntent viene creato fuori dalla Transaction (che si trova nella funzione qui sotto).
        Potrebbe quindi accadere che non venga utilizzato perchè nel frattempo l'ordine ha cambiato stato.
        In questo caso non c'è comunque alcun problema, in quanto si annullerà da solo dopo 7 giorni.
      */
      await _db.modifyOrder(orderId, order.id, cartAmount, deliveryAmount, orderProducts, newPaymentIntentId);
      _confirmLoadingController.value = false;
      return orderId;
    } catch (err) {
      _confirmLoadingController.value = false;
      throw err;
    }
  }

  // Crea il nuovo PaymentIntent a partire da quello vecchio
  Future<String> _processPayment(double cartAmount, double deliveryAmount, String orderId) async {
    var result = await _functions.createPaymentIntentFromPrevious(order.paymentIntentId, cartAmount + deliveryAmount, orderId);
    var confirmPaymentResult;
    try {
      confirmPaymentResult = await StripePayment.confirmPaymentIntent(PaymentIntent(
        clientSecret: result.clientSecret,
        paymentMethodId: result.paymentMethodId,
      ));
    } catch (err) {
      throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    }
    if (confirmPaymentResult.status != 'requires_capture') throw new PaymentIntentException("C'è stato un errore durante il pagamento.");
    return confirmPaymentResult.paymentIntentId;
  }
}
