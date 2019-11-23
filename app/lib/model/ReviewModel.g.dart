// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ReviewModel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReviewModel _$ReviewModelFromJson(Map json) {
  return ReviewModel(
      path: json['path'] as String,
      nominative: json['nominative'] as String,
      strPoints: json['strPoints'] as String,
      userId: json['userId'] as String,
      oid: json['oid'] as String,
      points: (json['points'] as num)?.toDouble());
}

Map<String, dynamic> _$ReviewModelToJson(ReviewModel instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('path', instance.path);
  val['points'] = instance.points;
  val['strPoints'] = instance.strPoints;
  val['oid'] = instance.oid;
  val['userId'] = instance.userId;
  val['nominative'] = instance.nominative;
  return val;
}
