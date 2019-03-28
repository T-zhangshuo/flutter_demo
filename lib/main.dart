import 'Constants/AppLibs.dart';
import 'pages/MainPage.dart';
import 'Utils/DioUtils.dart';

import 'provide/MainProvide.dart';

void main() {
  var providers = Providers();
  var subCategory = SubCategoryProvide();
  //添加状态
  providers.provide(Provider<SubCategoryProvide>.value(subCategory));

  runApp(ProviderNode(child: MainApp(), providers: providers));
}

class MainApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _initApp(context);
    return MaterialApp(
      title: "电商APP",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primaryColor: Colors.deepOrangeAccent),
      home: MainPage(),
    );
  }

  _initApp(BuildContext context) {
    new DioUtils();
  }
}
