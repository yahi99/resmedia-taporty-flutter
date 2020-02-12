import 'package:json_annotation/json_annotation.dart';
import 'package:stripe_payment/stripe_payment.dart';

part 'PaymentMethodModel.g.dart';

const Map<String, String> ASSET_OF_PAYMENT_CARD = {
  'americanExpress': "assets/payment_card/americanExpress.png",
  'dinersClub': "assets/payment_card/dinersClub.png",
  'discover': "assets/payment_card/discover.png",
  'JCB': "assets/payment_card/JCB.png",
  'mastercard': "assets/payment_card/mastercard.png",
  'visa': "assets/payment_card/visa.png",
};

const STRING_OF_PAYMENT_CARD = <String, String>{
  'americanExpress': "American Express",
  'dinersClub': "Diners Club",
  'discover': "Discover",
  'JCB': "JCB",
  'mastercard': "Mastercard",
  'unionPay': "UnionPay",
  'visa': "Visa",
};

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class PaymentMethodModel {
  final String id;
  final String customerId;
  final String type;
  final CreditCardModel card;

  PaymentMethodModel(
    this.id,
    this.type,
    this.customerId,
    this.card,
  );

  PaymentMethodModel.fromPaymentMethod(PaymentMethod paymentMethod)
      : this(
          paymentMethod.id,
          paymentMethod.type,
          paymentMethod.customerId,
          CreditCardModel.fromCreditCart(paymentMethod.card),
        );

  static PaymentMethodModel fromJson(Map json) => _$PaymentMethodModelFromJson(json);
  Map<String, dynamic> toJson() => _$PaymentMethodModelToJson(this);
}

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class CreditCardModel {
  final String brand;
  final String token;
  final String last4;
  final int expMonth;
  final int expYear;
  final String name;

  CreditCardModel(this.brand, this.token, this.last4, this.expMonth, this.expYear, this.name);

  CreditCardModel.fromCreditCart(CreditCard card)
      : this(
          card.brand,
          card.token,
          card.last4,
          card.expMonth,
          card.expYear,
          card.name,
        );

  static CreditCardModel fromJson(Map json) => _$CreditCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$CreditCardModelToJson(this);
}
