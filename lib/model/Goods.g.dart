part of 'Goods.dart';
Goods _$GoodsFromJson(Map<String,dynamic> json){
	return Goods()
		..oriPrice = json['oriPrice'] as num
		..image = json['image'] as String
		..goodsId = json['goodsId'] as String
		..presentPrice = json['presentPrice'] as num
		..goodsName = json['goodsName'] as String;
}
Map<String,dynamic> _$GoodsToJson(Goods instance) => 
	<String,dynamic>{
'oriPrice': instance.oriPrice,'image': instance.image,'goodsId': instance.goodsId,'presentPrice': instance.presentPrice,'goodsName': instance.goodsName};