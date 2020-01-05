import 'package:intl/intl.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HolidayModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class HolidayModel {
  final String name;

  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  final DateTime start;

  @JsonKey(fromJson: dateFromJson, toJson: dateToJson)
  final DateTime end;

  HolidayModel({
    this.name,
    this.start,
    this.end,
  });

  static DateTime dateFromJson(String input) {
    if (input == null) return null;
    return DateFormat("dd-MM").parse(input, true);
  }

  static String dateToJson(DateTime input) {
    return DateFormat("dd-MM").format(input);
  }

  static HolidayModel fromJson(Map json) => _$HolidayModelFromJson(json);
  Map<String, dynamic> toJson() => _$HolidayModelToJson(this);
}
