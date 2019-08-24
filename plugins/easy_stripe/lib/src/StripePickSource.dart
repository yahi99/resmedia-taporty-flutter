import 'package:easy_stripe/src/DefaultStripeController.dart';
import 'package:easy_stripe/src/StripeSourceView.dart';
import 'package:easy_stripe/src/StripeSourceModel.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/material.dart';




class StripePickSource extends StatelessWidget {
  final StripeManager manager;

  const StripePickSource({Key key,
    @required this.manager,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<StripeSourceModel>(
      stream: manager.outCard,
      builder: (_, snap) {
        if (snap.connectionState == ConnectionState.none)
          return Center(child: CircularProgressIndicator(),);

        if (!snap.hasData)
          return InkWell(
            onTap: manager.onAddPaymentCard,
            child: NoPaymentCard(),
          );

        return InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (_) => StripPickSourceDialog(
                manager: manager,
              ),
            );
          },
          child: StripeSourceView(
            manager: manager,
            model: snap.data,
          ),
        );
      },
    );
  }
}


class StripPickSourceDialog extends StatelessWidget {
  final StripeManager manager;

  const StripPickSourceDialog({Key key, @required this.manager}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PickPaymentCardDialog(
      onAddPaymentCard: manager.onAddPaymentCard,
      outCards: manager.outCards.map((cards) {
        return cards == null ? null : cards.map((card) {
          return InkWell(
            onTap: () => manager.inPickSource(card.id),
            child: StripeSourceView(
              manager: manager,
              model: card,
              isDense: true,
            ),
          );
        }).toList();
      }),
    );
  }
}
