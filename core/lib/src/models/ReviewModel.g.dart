// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReviewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map json) {
  return ReviewModel(
    path: json['path'] as String,
    customerName: json['customerName'] as String,
    description: json['description'] as String,
    userId: json['userId'] as String,
    orderId: json['orderId'] as String,
    rating: (json['rating'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['rating'] = instance.rating;
  val['description'] = instance.description;
  val['orderId'] = instance.orderId;
  val['userId'] = instance.userId;
  val['customerName'] = instance.customerName;
  return val;
}
