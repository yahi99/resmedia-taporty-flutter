import 'package:easy_stripe/easy_stripe.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_flutter/client/interface/screen/CheckoutScreen.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/BottonButtonBar.dart';
import 'package:resmedia_taporty_flutter/client/interface/view/InputField.dart';
import 'package:resmedia_taporty_flutter/common/logic/bloc/UserBloc.dart';

class PaymentPage extends StatefulWidget {
  final TabController controller;

  PaymentPage(this.controller);

  @override
  _PaymentState createState() => _PaymentState();
}

class _PaymentState extends State<PaymentPage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    var isValid = false;
    var cardId;
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    var userBloc = UserBloc.of();
    return StreamBuilder<StripeSourceModel>(
      stream: userBloc.stripeManager.outCard,
      builder: (ctx, cardSnapshot) {
        if (cardSnapshot.hasData) {
          isValid = true;
          cardId = cardSnapshot.data.token;
        }
        return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  widget.controller.animateTo(widget.controller.index - 1);
                },
              ),
            ),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("METODO DI PAGAMENTO", style: tt.subtitle),
                    Card(
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StripePickSource(
                          manager: userBloc.stripeManager,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            bottomNavigationBar: BottomButtonBar(
              color: theme.primaryColor,
              child: FlatButton(
                color: theme.primaryColor,
                child: Text(
                  "Continua",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () async {
                  if (isValid && cardId != null) {
                    final state = CheckoutScreenInheritedWidget.of(context);
                    state.cardId = cardId;
                    state.customerId = (await UserBloc.of().outFirebaseUser.first).uid;
                    widget.controller.animateTo(widget.controller.index + 1);
                  }
                },
              ),
            ));
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
