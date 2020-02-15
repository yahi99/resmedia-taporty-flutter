// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ShiftModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShiftModel _$ShiftModelFromJson(Map json) {
  return ShiftModel(
    path: json['path'] as String,
    endTime: datetimeFromTimestamp(json['endTime']),
    startTime: datetimeFromTimestamp(json['startTime']),
    availableDrivers: json['availableDrivers'] as int,
    driverReservations: (json['driverReservations'] as Map)?.map(
      (k, e) => MapEntry(k as String,
          e == null ? null : DriverReservationModel.fromJson(e as Map)),
    ),
  );
}

Map<String, dynamic> _$ShiftModelToJson(ShiftModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  writeNotNull('startTime', datetimeToTimestamp(instance.startTime));
  writeNotNull('endTime', datetimeToTimestamp(instance.endTime));
  writeNotNull('availableDrivers', instance.availableDrivers);
  writeNotNull('driverReservations',
      instance.driverReservations?.map((k, e) => MapEntry(k, e?.toJson())));
  return val;
}
