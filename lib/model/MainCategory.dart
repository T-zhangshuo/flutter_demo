import 'package:json_annotation/json_annotation.dart';
import 'SubCategory.dart';

part 'MainCategory.g.dart';
@JsonSerializable()
class MainCategory {
  MainCategory();

  String mallCategoryId;
  String mallCategoryName;
  List<SubCategory> bxMallSubDto;
  String comments;
  String image;
  
  factory MainCategory.fromJson(Map<String,dynamic> json) => _$MainCategoryFromJson(json);
  Map<String, dynamic> toJson() => _$MainCategoryToJson(this);
  static List<MainCategory> fromListJson(List jsonList){
    return jsonList.map((map) {
      return MainCategory.fromJson(map);
    }).toList();
  }
}