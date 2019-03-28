import 'NetConfig.dart';
import '../Utils/DioUtils.dart';

Future getHomePageContent() async {
  String api = API['homePageContent'];
  Map<String,dynamic>param = {"lon": "115.02932", 'lat': '35.76189'};
  return await DioUtils.getHttp().post(api, param);
}

Future getHomePageBelow(int page) async{
  String api=API['homePageBelow'];
  Map<String,dynamic> param={"page":page};
  return await DioUtils.getHttp().post(api,param);
}
