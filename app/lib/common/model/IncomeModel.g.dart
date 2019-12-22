// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'IncomeModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IncomeModel _$IncomeModelFromJson(Map json) {
  return IncomeModel(
      day: json['day'] as String,
      dailyTotal: (json['dailyTotal'] as num)?.toDouble(),
      totalTransactions: json['totalTransactions'] as int,
      path: json['path'] as String);
}

Map<String, dynamic> _$IncomeModelToJson(IncomeModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['totalTransactions'] = instance.totalTransactions;
  val['dailyTotal'] = instance.dailyTotal;
  val['day'] = instance.day;
  return val;
}
