import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_firebase/easy_firebase.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:meta/meta.dart';
import 'package:resmedia_taporty_core/core.dart';

part 'SupplierCategoryModel.g.dart';

@JsonSerializable(anyMap: true, explicitToJson: true)
class SupplierCategoryModel extends FirebaseModel {
  final String name;
  final String imageUrl;
  final List<SupplierTagModel> tags;

  SupplierCategoryModel({
    @required String path,
    @required this.name,
    @required this.imageUrl,
    @required this.tags,
  }) : super(path);

  static SupplierCategoryModel fromJson(Map json) => _$SupplierCategoryModelFromJson(json);

  static SupplierCategoryModel fromFirebase(DocumentSnapshot snap) => FirebaseModel.fromFirebase(fromJson, snap);

  Map<String, dynamic> toJson() => _$SupplierCategoryModelToJson(this);
}
