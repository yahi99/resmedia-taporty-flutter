import 'package:easy_widget/easy_widget.dart';
import 'package:json_annotation/json_annotation.dart';


part 'StripeSourceModel.g.dart';


@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class StripeSourceModel {
  final String id;
  final String token;
  final DateTime lastUse;

  final StripeCardModel card;

  StripeSourceModel({
    this.id, this.token,
    this.card, this.lastUse,
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
  final String exp_month;
  final String exp_year;

  StripeCardModel(this.brand, this.fingerprint, this.last4, this.exp_month,this.exp_year);

  static StripeCardModel fromJson(Map json) => _$StripeCardModelFromJson(json);
  Map<String, dynamic> toJson() => _$StripeCardModelToJson(this);

  static BrandOfPaymentCard brandFromJson(String str) => PAYMENT_CARD_OF_STRING[str];
  static String brandToJson(BrandOfPaymentCard brand) => STRING_OF_PAYMENT_CARD[brand];
}

