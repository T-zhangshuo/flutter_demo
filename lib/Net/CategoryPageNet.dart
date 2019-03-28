import 'NetConfig.dart';
import '../Utils/DioUtils.dart';
import '../module/MainCategory.dart';
import 'dart:convert';

Future<List<MainCategory>> getCategory() {
  String api = API['category'];
  Map<String, dynamic> param = {};
  return DioUtils.getHttp().post(api, param).then((data) {
    List dataList = (json.decode(data) as List).cast();
    return MainCategory.fromListJson(dataList);
  });
}
