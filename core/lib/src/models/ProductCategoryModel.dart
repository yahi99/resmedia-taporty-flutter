import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';

part 'ProductCategoryModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class ProductCategoryModel {
  final String id;
  final String name;

  ProductCategoryModel({
    @required this.id,
    @required this.name,
  });

  ProductCategoryModel.defaultValue() : this(id: "products", name: "Prodotti");

  static ProductCategoryModel fromJson(Map json) => _$ProductCategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductCategoryModelToJson(this);
}
