import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProductCartModel.g.dart';

/// Represents an instance of a product in the cart

@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductCartModel {
  final String id;
  final String userId;
  final String restaurantId;
  final int quantity;
  final double price;
  final String type;
  final bool delete;

  ProductCartModel({@required this.type, @required this.id, this.quantity: 0, @required this.restaurantId, @required this.userId, @required this.price, this.delete = false})
      : assert(quantity != null),
        assert(id != null);

  ProductCartModel decrease() {
    return copyWith(countProducts: quantity - 1);
  }

  ProductCartModel increment() {
    return copyWith(countProducts: quantity + 1);
  }

  @override
  bool operator ==(o) => o is ProductCartModel && o.id == id && o.restaurantId == restaurantId && o.userId == userId;

  String toString() => "ProductCart(id: $id, numItemsOrdered: $quantity, restaurantId: $restaurantId, userId: $userId)";

  ProductCartModel deleteItem(bool delete) {
    return ProductCartModel(id: id, restaurantId: restaurantId, quantity: quantity, userId: userId, price: price, type: type, delete: delete);
  }

  ProductCartModel copyWith({int countProducts}) {
    return ProductCartModel(id: id, quantity: countProducts, restaurantId: restaurantId, userId: userId, price: price, type: type, delete: delete);
  }

  static ProductCartModel fromJson(Map json) => _$ProductCartModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductCartModelToJson(this);
}
