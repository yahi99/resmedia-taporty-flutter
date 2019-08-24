import 'package:easy_stripe/easy_stripe.dart';
import 'package:easy_stripe/src/StripeSourceModel.dart';
import 'package:easy_widget/easy_widget.dart';
import 'package:flutter/widgets.dart';


class StripeSourceView extends StatelessWidget {
  final StripeSourceModel model;
  final StripeManager manager;
  final bool isDense;

  const StripeSourceView({Key key,
    @required this.manager,
    @required this.model,
    this.isDense: true,
  }) : assert(model != null), super(key: key);

  @override
  Widget build(BuildContext context) {
    return PaymentCard(
      assetFolder: manager.assetFolder,
      type: model.card.brand,
      last4: model.card.last4,
      isDense: isDense,
    );
  }
}
