import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:resmedia_taporty_driver/blocs/DriverBloc.dart';
import 'package:resmedia_taporty_driver/generated/provider.dart';

class StripeActivationConfirmScreen extends StatefulWidget {
  @override
  StripeActivationConfirmScreenState createState() => new StripeActivationConfirmScreenState();
}

class StripeActivationConfirmScreenState extends State<StripeActivationConfirmScreen> {
  final _driverBloc = $Provider.of<DriverBloc>();
  @override
  Widget build(BuildContext context) {
    final bool success = ModalRoute.of(context).settings.arguments;

    var theme = Theme.of(context);
    return Material(
      child: Theme(
        child: LogoView(
          logoHeight: 100,
          children: [
            Expanded(
              child: Column(
                children: <Widget>[
                  if (success) ...[
                    Text(
                      "Congratulazioni!",
                      style: theme.textTheme.title.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AutoSizeText(
                      "Hai attivato il tuo account Stripe con successo!",
                      style: theme.textTheme.body1.copyWith(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ] else ...[
                    Text(
                      "Qualcosa è andato storto...",
                      style: theme.textTheme.subtitle.copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    AutoSizeText(
                      "Riprova più tardi o contatta l'assistenza.",
                      style: theme.textTheme.body1.copyWith(color: Colors.white, fontSize: 17),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                  ],
                  RaisedButton(
                    onPressed: () async {
                      if (_driverBloc.firebaseUser != null) {
                        if (await _driverBloc.isStripeActivated())
                          Navigator.pushNamedAndRemoveUntil(context, "/home", (route) => false);
                        else
                          await Navigator.popAndPushNamed(context, "/stripeActivation");
                      } else
                        await Navigator.popAndPushNamed(context, "/login");
                    },
                    child: FittedText('Continua'),
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
