import 'NetConfig.dart';
import '../Utils/DioUtils.dart';
import '../model/MainCategory.dart';
import '../model/Goods.dart';
import 'dart:convert';

Future<List<MainCategory>> getCategory() {
  String api = API['category'];
  Map<String, dynamic> param = {};
  return DioUtils.getHttp().post(api, param).then((data) {
    List dataList = (json.decode(data) as List).cast();
    return MainCategory.fromListJson(dataList);
  });
}

Future<List<Goods>> getCategoryGoods(String id, String subId, int page) {
  String api = API['categoryGoods'];
  Map<String, dynamic> param = {
    "categoryId": id,
    "categorySubId": subId,
    "page": page
  };
  return DioUtils.getHttp().post(api, param).then((data) {
    return Goods.fromListJson((json.decode(data) as List).cast());
  });
}
