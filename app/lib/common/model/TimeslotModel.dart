import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'TimeslotModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class TimeslotModel {
  @JsonKey(fromJson: timeFromJson, toJson: timeToJson)
  final DateTime start;

  @JsonKey(fromJson: timeFromJson, toJson: timeToJson)
  final DateTime end;

  TimeslotModel({
    this.start,
    this.end,
  });

  static DateTime timeFromJson(String input) {
    if (input == null) return null;
    return DateFormat("HH:mm").parse(input, true);
  }

  static String timeToJson(DateTime input) {
    return DateFormat("HH:mm").format(input);
  }

  static TimeslotModel fromJson(Map json) => _$TimeslotModelFromJson(json);
  Map<String, dynamic> toJson() => _$TimeslotModelToJson(this);
}
