// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SubjectModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SubjectModel _$SubjectModelFromJson(Map<String, dynamic> json) {
  return SubjectModel(
      day: json['day'] as String,
      title: json['title'] as String,
      address: json['address'] as String,
      time: json['time'] as String,
      deliveryTime: json['deliveryTime'] as String,
      position: json['position'] == null
          ? null
          : LatLngModel.fromJson(json['position'] as Map<String, dynamic>));
}

Map<String, dynamic> _$SubjectModelToJson(SubjectModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'address': instance.address,
      'time': instance.time,
      'position': instance.position,
      'day': instance.day,
      'deliveryTime': instance.deliveryTime
    };

LatLngModel _$LatLngModelFromJson(Map<String, dynamic> json) {
  return LatLngModel(
      lat: (json['lat'] as num)?.toDouble(),
      lng: (json['lng'] as num)?.toDouble());
}

Map<String, dynamic> _$LatLngModelToJson(LatLngModel instance) =>
    <String, dynamic>{'lat': instance.lat, 'lng': instance.lng};
