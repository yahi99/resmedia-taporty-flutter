import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'IntentCreationResult.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, nullable: true, includeIfNull: false)
class IntentCreationResult {
  final bool success;
  final String error;
  final String paymentIntentId;
  final String clientSecret;

  IntentCreationResult(
    this.success,
    this.error,
    this.paymentIntentId,
    this.clientSecret,
  );

  static IntentCreationResult fromJson(Map json) => _$IntentCreationResultFromJson(json);

  Map<String, dynamic> toJson() => _$IntentCreationResultToJson(this);

  @required
  String toString() => toJson().toString();
}
