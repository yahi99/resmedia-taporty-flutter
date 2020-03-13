import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'OrderProductModel.g.dart';

/// Rappresenta un prodotto di un ordine già eseguito

@JsonSerializable(anyMap: true, explicitToJson: true)
class OrderProductModel {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  int quantity;
  @JsonKey(defaultValue: "")
  String notes;

  OrderProductModel({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
    @required this.imageUrl,
    this.notes,
  });

  static OrderProductModel fromJson(Map json) => _$OrderProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderProductModelToJson(this);

  @required
  String toString() => toJson().toString();
}
