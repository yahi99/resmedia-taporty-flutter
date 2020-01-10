import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'CartProductModel.g.dart';

/// Represents an instance of a product in the cart

@JsonSerializable(anyMap: true, explicitToJson: true)
class CartProductModel {
  final String id;
  final String userId;
  final String restaurantId;
  final int quantity;
  final double price;
  final String type;
  final bool delete;

  CartProductModel({@required this.type, @required this.id, this.quantity: 0, @required this.restaurantId, @required this.userId, @required this.price, this.delete = false})
      : assert(quantity != null),
        assert(id != null);

  CartProductModel decrease() {
    return copyWith(countProducts: quantity - 1);
  }

  CartProductModel increment() {
    return copyWith(countProducts: quantity + 1);
  }

  @override
  int get hashCode => super.hashCode;

  @override
  bool operator ==(o) => o is CartProductModel && o.id == id && o.restaurantId == restaurantId && o.userId == userId;

  String toString() => "ProductCart(id: $id, numItemsOrdered: $quantity, restaurantId: $restaurantId, userId: $userId)";

  CartProductModel deleteItem(bool delete) {
    return CartProductModel(id: id, restaurantId: restaurantId, quantity: quantity, userId: userId, price: price, type: type, delete: delete);
  }

  CartProductModel copyWith({int countProducts}) {
    return CartProductModel(id: id, quantity: countProducts, restaurantId: restaurantId, userId: userId, price: price, type: type, delete: delete);
  }

  static CartProductModel fromJson(Map json) => _$CartProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$CartProductModelToJson(this);
}
