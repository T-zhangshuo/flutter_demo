part of 'MainCategory.dart';
MainCategory _$MainCategoryFromJson(Map<String,dynamic> json){
	return MainCategory()
		..mallCategoryId = json['mallCategoryId'] as String
		..mallCategoryName = json['mallCategoryName'] as String
		..bxMallSubDto = (json['bxMallSubDto'] as List )?.map((e) => e == null ? null: SubCategory.fromJson(e as Map<String,dynamic>))?.toList()
		..comments = json['comments'] as String
		..image = json['image'] as String;
}
Map<String,dynamic> _$MainCategoryToJson(MainCategory instance) => 
	<String,dynamic>{
'mallCategoryId': instance.mallCategoryId,'mallCategoryName': instance.mallCategoryName,'bxMallSubDto': instance.bxMallSubDto,'comments': instance.comments,'image': instance.image};