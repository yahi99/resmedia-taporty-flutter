// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TypesRestaurantModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TypesRestaurantModel _$TypesRestaurantModelFromJson(Map json) {
  return TypesRestaurantModel(
    path: json['path'] as String,
    img: json['img'] as String,
  );
}

Map<String, dynamic> _$TypesRestaurantModelToJson(
    TypesRestaurantModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['img'] = instance.img;
  return val;
}
