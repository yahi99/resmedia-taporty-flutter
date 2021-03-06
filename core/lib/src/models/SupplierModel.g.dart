// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SupplierModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierModel _$SupplierModelFromJson(Map json) {
  return SupplierModel(
    path: json['path'] as String,
    name: json['name'] as String,
    description: json['description'] as String,
    geohashPoint: json['geohashPoint'] == null
        ? null
        : GeohashPointModel.fromJson(json['geohashPoint'] as Map),
    category: json['category'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    holidays: (json['holidays'] as List)
        ?.map((e) => e == null ? null : HolidayModel.fromJson(e as Map))
        ?.toList(),
    weekdayTimetable: (json['weekdayTimetable'] as Map)?.map(
      (k, e) => MapEntry(int.parse(k as String),
          e == null ? null : TimetableModel.fromJson(e as Map)),
    ),
    categories: (json['categories'] as List)
        ?.map((e) => e == null ? null : ProductCategoryModel.fromJson(e as Map))
        ?.toList(),
    thumbnailUrl: json['thumbnailUrl'] as String,
    address: json['address'] as String,
    phoneNumber: json['phoneNumber'] as String,
    rating: (json['rating'] as num)?.toDouble(),
    reviewCount: json['reviewCount'] as int,
    isDisabled: json['isDisabled'] as bool,
    imageUrl: json['imageUrl'] as String,
  );
}

Map<String, dynamic> _$SupplierModelToJson(SupplierModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['name'] = instance.name;
  val['description'] = instance.description;
  val['imageUrl'] = instance.imageUrl;
  val['thumbnailUrl'] = instance.thumbnailUrl;
  val['phoneNumber'] = instance.phoneNumber;
  val['category'] = instance.category;
  val['tags'] = instance.tags;
  val['geohashPoint'] = instance.geohashPoint?.toJson();
  val['address'] = instance.address;
  val['holidays'] = instance.holidays?.map((e) => e?.toJson())?.toList();
  val['weekdayTimetable'] = instance.weekdayTimetable
      ?.map((k, e) => MapEntry(k.toString(), e?.toJson()));
  val['reviewCount'] = instance.reviewCount;
  val['rating'] = instance.rating;
  val['isDisabled'] = instance.isDisabled;
  val['categories'] = instance.categories?.map((e) => e?.toJson())?.toList();
  return val;
}
