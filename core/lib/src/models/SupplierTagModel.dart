import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'SupplierTagModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class SupplierTagModel {
  final String id;
  final String name;

  SupplierTagModel({
    @required this.id,
    @required this.name,
  });

  static SupplierTagModel fromJson(Map json) => _$SupplierTagModelFromJson(json);

  Map<String, dynamic> toJson() => _$SupplierTagModelToJson(this);
}
