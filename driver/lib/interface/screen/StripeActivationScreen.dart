import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/StripeBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class StripeActivationScreen extends StatefulWidget {
  @override
  StripeActivationScreenState createState() => new StripeActivationScreenState();
}

class StripeActivationScreenState extends State<StripeActivationScreen> {
  var _stripeBloc = $Provider.of<StripeBloc>();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Material(
      child: Theme(
        child: LogoView(
          logoHeight: 100,
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  Text(
                    "Benvenuto!",
                    style: theme.textTheme.title.copyWith(color: Colors.white),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  AutoSizeText(
                    "Per procedere all'utilizzo della piattaforma è necessario compilare un altro modulo per l'utilizzo di Stripe, il partner con cui gestiamo i pagamenti.",
                    style: theme.textTheme.body1.copyWith(color: Colors.white, fontSize: 17),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  RaisedButton(
                    onPressed: () async {
                      await _stripeBloc.initStripeActivation();
                    },
                    child: FittedText('Attiva Stripe'),
                  ),
                ],
              ),
            ),
          ],
        ),
        data: Theme.of(context).copyWith(unselectedWidgetColor: Colors.white),
      ),
    );
  }
}
