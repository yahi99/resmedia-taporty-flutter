// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'OrderModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DriverOrderModel _$DriverOrderModelFromJson(Map json) {
  return DriverOrderModel(
      path: json['path'] as String,
      phone: json['phone'] as String,
      day: json['day'] as String,
      startTime: json['startTime'] as String,
      endTime: json['endTime'] as String,
      titleR: json['titleR'] as String,
      titleS: json['titleS'] as String,
      addressS: json['addressS'] as String,
      addressR: json['addressR'] as String,
      timeS: json['timeS'] as String,
      timeR: json['timeR'] as String,
      latR: (json['latR'] as num)?.toDouble(),
      lngR: (json['lngR'] as num)?.toDouble(),
      state: _$enumDecodeNullable(_$StateCategoryEnumMap, json['state']),
      uid: json['uid'] as String,
      restId: json['restId'] as String)
    ..nominative = json['nominative'] as String;
}

Map<String, dynamic> _$DriverOrderModelToJson(DriverOrderModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('titleR', instance.titleR);
  writeNotNull('titleS', instance.titleS);
  writeNotNull('addressR', instance.addressR);
  writeNotNull('addressS', instance.addressS);
  writeNotNull('timeR', instance.timeR);
  writeNotNull('timeS', instance.timeS);
  writeNotNull('latR', instance.latR);
  writeNotNull('lngR', instance.lngR);
  writeNotNull('restId', instance.restId);
  writeNotNull('uid', instance.uid);
  writeNotNull('nominative', instance.nominative);
  writeNotNull('day', instance.day);
  writeNotNull('endTime', instance.endTime);
  writeNotNull('startTime', instance.startTime);
  writeNotNull('phone', instance.phone);
  writeNotNull('state', _$StateCategoryEnumMap[instance.state]);
  return val;
}

T _$enumDecode<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }
  return enumValues.entries
      .singleWhere((e) => e.value == source,
          orElse: () => throw ArgumentError(
              '`$source` is not one of the supported values: '
              '${enumValues.values.join(', ')}'))
      .key;
}

T _$enumDecodeNullable<T>(Map<T, dynamic> enumValues, dynamic source) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source);
}

const _$StateCategoryEnumMap = <StateCategory, dynamic>{
  StateCategory.PENDING: 'PENDING',
  StateCategory.ACCEPTED: 'ACCEPTED',
  StateCategory.DELIVERED: 'DELIVERED',
  StateCategory.DENIED: 'DENIED',
  StateCategory.PICKED_UP: 'PICKED_UP',
  StateCategory.CANCELLED: 'CANCELLED'
};
