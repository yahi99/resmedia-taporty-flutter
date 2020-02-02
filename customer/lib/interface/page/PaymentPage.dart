import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
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

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final tt = theme.textTheme;
    var stripeBloc = $Provider.of<StripeBloc>();
    return StreamBuilder<StripeSourceModel>(
      stream: stripeBloc.outSource,
      builder: (ctx, cardSnapshot) {
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
                  // TODO: Sistemare
                  /*Card(
                      margin: const EdgeInsets.all(16.0),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: StripePickSource(
                          manager: userBloc.stripeManager,
                        ),
                      ),
                    ),*/
                ],
              ),
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
                    if (true) {
                      var index = widget.controller.index;
                      widget.controller.animateTo(index + 1);
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}
