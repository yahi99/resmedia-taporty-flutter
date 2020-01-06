// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ProductCartFirebase.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductCartFirebase _$ProductCartFirebaseFromJson(Map json) {
  return ProductCartFirebase(
    id: json['id'] as String,
    countProducts: json['countProducts'] as int,
    delete: json['delete'] as bool,
    restaurantId: json['restaurantId'] as String,
    userId: json['userId'] as String,
    price: (json['price'] as num)?.toDouble(),
    type: json['category'] as String,
  );
}

Map<String, dynamic> _$ProductCartFirebaseToJson(ProductCartFirebase instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  writeNotNull('countProducts', instance.countProducts);
  writeNotNull('restaurantId', instance.restaurantId);
  writeNotNull('userId', instance.userId);
  writeNotNull('price', instance.price);
  writeNotNull('category', instance.type);
  writeNotNull('delete', instance.delete);
  return val;
}
