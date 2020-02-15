import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_customer/interface/view/StripeCardView.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:resmedia_taporty_customer/blocs/CheckoutBloc.dart';
import 'package:resmedia_taporty_customer/blocs/StripeBloc.dart';
import 'package:resmedia_taporty_customer/generated/provider.dart';
import 'package:resmedia_taporty_customer/interface/view/BottonButtonBar.dart';

class PaymentPage extends StatefulWidget {
  final TabController controller;

  PaymentPage(this.controller);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> with AutomaticKeepAliveClientMixin {
  final checkoutBloc = $Provider.of<CheckoutBloc>();
  final stripeBloc = $Provider.of<StripeBloc>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            HeaderWidget("METODO DI PAGAMENTO"),
            StreamBuilder<PaymentMethod>(
              stream: stripeBloc.outPaymentMethod,
              builder: (context, paymentMethodSnap) {
                var cardWidget;
                if (!paymentMethodSnap.hasData)
                  cardWidget = Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Text(
                          "Inserisci una carta",
                          style: tt.subtitle,
                        ),
                      ],
                    ),
                  );
                else
                  cardWidget = StripeCardView(
                    card: paymentMethodSnap.data.card,
                  );
                return Card(
                  margin: const EdgeInsets.all(16.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        try {
                          PaymentMethod method = await StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest());
                          stripeBloc.setPaymentMethod(method);
                        } catch (err) {
                          print(err);
                        }
                      },
                      child: cardWidget,
                    ),
                  ),
                );
              },
            ),
            // Mantieni e magari implementa in futuro
            /*if (Platform.isAndroid)
              FlatButton.icon(
                icon: Icon(FontAwesomeIcons.google),
                label: Text("Pay"),
                onPressed: _initNativePay,
              ),
            if (Platform.isIOS)
              IconButton(
                icon: Icon(FontAwesomeIcons.applePay),
                onPressed: _initNativePay,
              ),*/
          ],
        ),
      ),
      bottomNavigationBar: BottomButtonBar(
        color: theme.primaryColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              color: theme.primaryColor,
              child: Text(
                "Indietro",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                widget.controller.animateTo(widget.controller.index - 1);
              },
            ),
            FlatButton(
              color: theme.primaryColor,
              child: Text(
                "Continua",
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () async {
                if (stripeBloc.paymentMethod != null) {
                  var index = widget.controller.index;
                  widget.controller.animateTo(index + 1);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
  // Mantieni e magari implementa in futuro
  /*void _initNativePay() async {
    Token t = await StripePayment.paymentRequestWithNativePay(
      androidPayOptions: AndroidPayPaymentRequest(
        currency_code: "eur",
        billing_address_required: false,
        shipping_address_required: false,
        total_price: "10",
      ),
      applePayOptions: null,
    );
    PaymentMethod pm = await StripePayment.createPaymentMethod(PaymentMethodRequest(card: t.card, token: t));
    stripeBloc.setPaymentMethod(pm);
  }*/

  @override
  bool get wantKeepAlive => true;
}
