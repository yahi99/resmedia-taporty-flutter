import 'package:easy_blocs/easy_blocs.dart';
import 'package:easy_firebase/src/database/Models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'ProductCartFirebase.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, includeIfNull: false)
class ProductCartFirebase extends PartialDocumentModel implements ProductCart {
  @override
  final int countProducts;
  final String restaurantId;
  final String userId;
  final double price;
  final String category;
  final bool delete;

  ProductCartFirebase({String id, this.countProducts,this.delete,this.restaurantId, this.userId,this.price,this.category}) : super(id);

  ProductCart decrease() {
    return copyWith(countProducts: countProducts-1);
  }

  ProductCart increment() {
    return copyWith(countProducts: countProducts+1);
  }

  ProductCartFirebase deleteItem(bool delete){
    return ProductCartFirebase(
        id: id,
        restaurantId:restaurantId,
        countProducts: countProducts,
        userId: userId,
        price: price,
        category: category,
        delete: delete
    );
  }

  @override
  ProductCartFirebase copyWith({int countProducts}) {
    return ProductCartFirebase(
      id: id,
      restaurantId:restaurantId,
      countProducts: countProducts,
      userId: userId,
      price: price,
      category: category,
      delete: delete
    );
  }

  String toString() => "ProductCartFirebase(id: $id, countProducts: $countProducts, restaurantId: $restaurantId, userId: $userId)";

  static ProductCartFirebase fromJson(Map json) {
    return _$ProductCartFirebaseFromJson(json);
  }
    Map<String, dynamic> toJson() => _$ProductCartFirebaseToJson(this);
}