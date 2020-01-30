import 'package:json_annotation/json_annotation.dart';

part 'StripeSourceModel.g.dart';

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

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class StripeSourceModel {
  final String id;
  final String token;
  final DateTime lastUse;

  final StripeCardModel card;

  StripeSourceModel({
    this.id,
    this.token,
    this.card,
    this.lastUse,
  });

  static StripeSourceModel fromJson(Map json) => _$StripeSourceModelFromJson(json);
  Map<String, dynamic> toJson() => _$StripeSourceModelToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class StripeCardModel {
  @JsonKey(fromJson: brandFromJson, toJson: brandToJson)
  final BrandOfPaymentCard brand;
  final String fingerprint;
  final String last4;
  final int expMonth;
  final int expYear;
  final String name;

  StripeCardModel(this.brand, this.fingerprint, this.last4, this.expMonth, this.expYear, this.name);

  static StripeCardModel fromJson(Map json) => _$StripeCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$StripeCardModelToJson(this);

  static BrandOfPaymentCard brandFromJson(String str) => PAYMENT_CARD_OF_STRING[str];
  static String brandToJson(BrandOfPaymentCard brand) => STRING_OF_PAYMENT_CARD[brand];
}
