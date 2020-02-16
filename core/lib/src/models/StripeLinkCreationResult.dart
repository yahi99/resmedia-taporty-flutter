import 'package:flutter/widgets.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'StripeLinkCreationResult.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true, nullable: true, includeIfNull: false)
class StripeLinkCreationResult {
  final bool success;
  final String error;
  final String link;

  StripeLinkCreationResult(
    this.success,
    this.error,
    this.link,
  );

  static StripeLinkCreationResult fromJson(Map json) => _$StripeLinkCreationResultFromJson(json);

  Map<String, dynamic> toJson() => _$StripeLinkCreationResultToJson(this);

  @required
  String toString() => toJson().toString();
}
