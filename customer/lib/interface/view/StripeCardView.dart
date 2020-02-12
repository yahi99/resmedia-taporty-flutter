import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:resmedia_taporty_core/core.dart';
import 'package:stripe_payment/stripe_payment.dart';

class StripeCardView extends StatelessWidget {
  static const PAINT_SIZE = 64.0;
  final CreditCard card;

  const StripeCardView({
    Key key,
    @required this.card,
  })  : assert(card != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final assetPath = ASSET_OF_PAYMENT_CARD[card.brand];
    final brandName = STRING_OF_PAYMENT_CARD[card.brand];

    var cardImageWidget = assetPath == null
        ? const Icon(
            Icons.credit_card,
            size: PAINT_SIZE,
          )
        : Image.asset(
            assetPath,
            width: PAINT_SIZE,
            height: PAINT_SIZE,
            fit: BoxFit.contain,
          );
    return Row(
      children: <Widget>[
        cardImageWidget,
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                brandName == null ? "Unknown" : brandName,
                style: textTheme.subtitle,
              ),
              Text(
                "**** **** **** ${card.last4}",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
