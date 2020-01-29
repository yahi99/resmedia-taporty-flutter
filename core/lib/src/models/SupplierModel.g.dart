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
    coordinates: geopointFromJson(json['coordinates']),
    category: json['category'] as String,
    tags: (json['tags'] as List)?.map((e) => e as String)?.toList(),
    holidays: (json['holidays'] as List)
        ?.map((e) => e == null ? null : HolidayModel.fromJson(e as Map))
        ?.toList(),
    weekdayTimetable: (json['weekdayTimetable'] as Map)?.map(
      (k, e) => MapEntry(int.parse(k as String),
          e == null ? null : TimetableModel.fromJson(e as Map)),
    ),
    address: json['address'] as String,
    phoneNumber: json['phoneNumber'] as String,
    averageReviews: (json['averageReviews'] as num)?.toDouble(),
    numberOfReviews: json['numberOfReviews'] as int,
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
  val['phoneNumber'] = instance.phoneNumber;
  val['category'] = instance.category;
  val['tags'] = instance.tags;
  val['coordinates'] = geopointToJson(instance.coordinates);
  val['address'] = instance.address;
  val['holidays'] = instance.holidays?.map((e) => e?.toJson())?.toList();
  val['weekdayTimetable'] = instance.weekdayTimetable
      ?.map((k, e) => MapEntry(k.toString(), e?.toJson()));
  val['numberOfReviews'] = instance.numberOfReviews;
  val['averageReviews'] = instance.averageReviews;
  val['isDisabled'] = instance.isDisabled;
  return val;
}
