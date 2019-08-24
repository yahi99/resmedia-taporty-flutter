import 'package:easy_stripe/easy_stripe.dart';
import 'package:easy_stripe/src/DefaultStripeController.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';


class StripeSourcesScreen extends StatelessWidget {
  final StripeManager manager;

  const StripeSourcesScreen({Key key, @required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaymentCardsScreen(
      onAddPaymentCard: manager.onAddPaymentCard,
      outCards: manager.outCards.map((cards) {
        if (cards == null) return null;
        return cards.map((card) {
          return StripeSourceView(
            manager: manager,
            model: card,
          );
        }).toList();
      }),
    );
  }
}



