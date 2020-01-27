import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CartProductModel.g.dart';

/// Rappresenta una istanza di un prodotto in un carrello

@JsonSerializable(anyMap: true, explicitToJson: true)
class CartProductModel {
  final String id;
  final int quantity;
  final double price;
  final String type;

  CartProductModel({
    @required this.type,
    @required this.id,
    this.quantity: 0,
    @required this.price,
  })  : assert(quantity != null),
        assert(id != null);

  double get totalPrice => price * quantity.toDouble();

  CartProductModel decrease() {
    return copyWith(countProducts: quantity - 1);
  }

  CartProductModel increment() {
    return copyWith(countProducts: quantity + 1);
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(o) => o is CartProductModel && o.id == id;

  CartProductModel copyWith({int countProducts}) {
    return CartProductModel(id: id, quantity: countProducts, price: price, type: type);
  }

  static CartProductModel fromJson(Map json) => _$CartProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductModelToJson(this);
}
