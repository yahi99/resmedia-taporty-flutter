import 'package:json_annotation/json_annotation.dart';
import 'package:resmedia_taporty_flutter/common/model/TimeslotModel.dart';

part 'TimetableModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class TimetableModel {
  final bool open;
  final int timeslotCount;
  final List<TimeslotModel> timeslots;

  TimetableModel({
    this.open,
    this.timeslotCount,
    this.timeslots,
  });

  static TimetableModel fromJson(Map json) => _$TimetableModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimetableModelToJson(this);
}
