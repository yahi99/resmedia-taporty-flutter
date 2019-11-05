// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'RestaurantRequestModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RestaurantRequestModel _$RestaurantRequestModelFromJson(Map json) {
  return RestaurantRequestModel(
      path: json['path'] as String,
      lat: (json['lat'] as num)?.toDouble(),
      address: json['address'] as String,
      prodType: json['prodType'] as String,
      img: json['img'] as String,
      partitaIva: json['partitaIva'] as String,
      tipoEsercizio: json['tipoEsercizio'] as String,
      km: (json['km'] as num)?.toDouble(),
      ragioneSociale: json['ragioneSociale'] as String,
      lng: (json['lng'] as num)?.toDouble());
}

Map<String, dynamic> _$RestaurantRequestModelToJson(
    RestaurantRequestModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('img', instance.img);
  writeNotNull('address', instance.address);
  writeNotNull('partitaIva', instance.partitaIva);
  writeNotNull('prodType', instance.prodType);
  writeNotNull('tipoEsercizio', instance.tipoEsercizio);
  writeNotNull('ragioneSociale', instance.ragioneSociale);
  writeNotNull('lat', instance.lat);
  writeNotNull('lng', instance.lng);
  writeNotNull('km', instance.km);
  return val;
}
