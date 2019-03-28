import 'NetConfig.dart';
import 'package:flutter/material.dart';
import '../Utils/DioUtils.dart';

Future getHomePageContent(BuildContext context) async {
  String api = API['homePageContent'];
  var param = {"lon": "115.02932", 'lat': '35.76189'};
  return await DioUtils.getHttp(context).post(api, param);
}
