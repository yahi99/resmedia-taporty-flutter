// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestaurantModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map json) {
  return RestaurantModel(
      path: json['path'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      type: json['type'] as String,
      img: json['img'] as String,
      lng: (json['lng'] as num)?.toDouble(),
      lat: (json['lat'] as num)?.toDouble(),
      km: (json['km'] as num)?.toDouble());
}

Map<String, dynamic> _$RestaurantModelToJson(RestaurantModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['title'] = instance.title;
  val['description'] = instance.description;
  val['img'] = instance.img;
  val['type'] = instance.type;
  val['lat'] = instance.lat;
  val['lng'] = instance.lng;
  val['km'] = instance.km;
  return val;
}
