// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SupplierCategoryModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierCategoryModel _$SupplierCategoryModelFromJson(Map json) {
  return SupplierCategoryModel(
    path: json['path'] as String,
    name: json['name'] as String,
    imageUrl: json['imageUrl'] as String,
    tags: (json['tags'] as List)
        ?.map((e) => e == null ? null : SupplierTagModel.fromJson(e as Map))
        ?.toList(),
  );
}

Map<String, dynamic> _$SupplierCategoryModelToJson(
    SupplierCategoryModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['name'] = instance.name;
  val['imageUrl'] = instance.imageUrl;
  val['tags'] = instance.tags?.map((e) => e?.toJson())?.toList();
  return val;
}
