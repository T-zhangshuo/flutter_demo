import 'package:json_annotation/json_annotation.dart';

part 'Goods.g.dart';
@JsonSerializable()
class Goods {
  Goods();

  num oriPrice;
  String image;
  String goodsId;
  num presentPrice;
  String goodsName;
  
  factory Goods.fromJson(Map<String,dynamic> json) => _$GoodsFromJson(json);
  Map<String, dynamic> toJson() => _$GoodsToJson(this);
  static List<Goods> fromListJson(List jsonList){
    return jsonList.map((map) {
      return Goods.fromJson(map);
    }).toList();
  }
}