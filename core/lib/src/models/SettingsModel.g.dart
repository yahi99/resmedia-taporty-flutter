// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'SettingsModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SettingsModel _$SettingsModelFromJson(Map json) {
  return SettingsModel(
    (json['supplierPercentage'] as num)?.toDouble(),
    (json['deliveryAmount'] as num)?.toDouble(),
    (json['driverAmount'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$SettingsModelToJson(SettingsModel instance) =>
    <String, dynamic>{
      'supplierPercentage': instance.supplierPercentage,
      'driverAmount': instance.driverAmount,
      'deliveryAmount': instance.deliveryAmount,
    };
