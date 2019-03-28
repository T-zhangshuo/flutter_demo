part of 'SubCategory.dart';
SubCategory _$SubCategoryFromJson(Map<String,dynamic> json){
	return SubCategory()
		..mallSubId = json['mallSubId'] as String
		..mallCategoryId = json['mallCategoryId'] as String
		..mallSubName = json['mallSubName'] as String
		..comments = json['comments'] as String;
}
Map<String,dynamic> _$SubCategoryToJson(SubCategory instance) => 
	<String,dynamic>{
'mallSubId': instance.mallSubId,'mallCategoryId': instance.mallCategoryId,'mallSubName': instance.mallSubName,'comments': instance.comments};