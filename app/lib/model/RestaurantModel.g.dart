// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestaurantModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantModel _$RestaurantModelFromJson(Map json) {
  return RestaurantModel(
      path: json['path'] as String,
      isDisabled: json['isDisabled'] as bool,
      lunch: (json['lunch'] as Map)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      dinner: (json['dinner'] as Map)?.map(
        (k, e) => MapEntry(k as String, e as String),
      ),
      deliveryFee: (json['deliveryFee'] as num)?.toDouble(),
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
  val['deliveryFee'] = instance.deliveryFee;
  val['lunch'] = instance.lunch;
  val['dinner'] = instance.dinner;
  val['isDisabled'] = instance.isDisabled;
  return val;
}
