import 'package:flutter/material.dart';

enum BrandOfPaymentCard {
  americanExpress,
  dinersClub,
  discover,
  JCB,
  mastercard,
  unionPay,
  visa,
}

const Map<BrandOfPaymentCard, String> ASSET_OF_PAYMENT_CARD = {
  BrandOfPaymentCard.americanExpress: "packages/easy_widget/assets/imgs/payment_card/americanExpress.png",
  BrandOfPaymentCard.dinersClub: "packages/easy_widget/assets/imgs/payment_card/dinersClub.png",
  BrandOfPaymentCard.discover: "packages/easy_widget/assets/imgs/payment_card/discover.png",
  BrandOfPaymentCard.JCB: "packages/easy_widget/assets/imgs/payment_card/JCB.png",
  BrandOfPaymentCard.mastercard: "packages/easy_widget/assets/imgs/payment_card/mastercard.png",
  BrandOfPaymentCard.unionPay: null,
  BrandOfPaymentCard.visa: "packages/easy_widget/assets/imgs/payment_card/visa.png",
};

const STRING_OF_PAYMENT_CARD = <BrandOfPaymentCard, String>{
  BrandOfPaymentCard.americanExpress: "American Express",
  BrandOfPaymentCard.dinersClub: "Diners Club",
  BrandOfPaymentCard.discover: "Discover",
  BrandOfPaymentCard.JCB: "JCB",
  BrandOfPaymentCard.mastercard: "Mastercard",
  BrandOfPaymentCard.unionPay: "UnionPay",
  BrandOfPaymentCard.visa: "Visa",
},
    PAYMENT_CARD_OF_STRING = <String, BrandOfPaymentCard>{
  "American Express": BrandOfPaymentCard.americanExpress,
  "Diners Club": BrandOfPaymentCard.dinersClub,
  "Discover": BrandOfPaymentCard.discover,
  "JCB": BrandOfPaymentCard.JCB,
  "MasterCard": BrandOfPaymentCard.mastercard,
  "UnionPay": BrandOfPaymentCard.unionPay,
  "Visa": BrandOfPaymentCard.visa,
};

class PaymentCard extends StatelessWidget {
  static const PAINT_SIZE = 64.0;

  final BrandOfPaymentCard type;
  final String last4;
  final bool isDense;

  PaymentCard({
    Key key,
    @required this.type,
    @required this.last4,
    this.isDense: false,
  }) : super(key: key);

  static String getPathImage(String path, String title) {
    return '$path/$title.png';
  }

  static Iterable<String> getPathImages(String path) {
    return PAYMENT_CARD_OF_STRING.keys.map((title) {
      return getPathImage(path, title);
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tt = theme.textTheme;

    final assetPath = type == null ? null : ASSET_OF_PAYMENT_CARD[type];

    return Row(
      children: <Widget>[
        assetPath == null
            ? const Icon(
                Icons.credit_card,
                size: PAINT_SIZE,
              )
            : Image.asset(
                assetPath,
                width: PAINT_SIZE,
                height: PAINT_SIZE,
                fit: BoxFit.contain,
              ),
        Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                type == null ? "Unknown" : STRING_OF_PAYMENT_CARD[type],
                style: tt.subtitle,
              ),
              Text(
                "**** **** **** $last4",
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
