import 'package:json_annotation/json_annotation.dart';

part 'SubCategory.g.dart';
@JsonSerializable()
class SubCategory {
  SubCategory();

  String mallSubId;
  String mallCategoryId;
  String mallSubName;
  String comments;
  
  factory SubCategory.fromJson(Map<String,dynamic> json) => _$SubCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$SubCategoryToJson(this);
  static List<SubCategory> fromListJson(List jsonList){
    return jsonList.map((map) {
      return SubCategory.fromJson(map);
    }).toList();
  }
}