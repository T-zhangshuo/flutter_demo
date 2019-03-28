import 'Constants/AppLibs.dart';
import 'pages/MainPage.dart';
import 'Utils/DioUtils.dart';

void main() => runApp(MainApp());

class MainApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    _initApp(context);
    return MaterialApp(
      title: "电商APP",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.deepOrangeAccent
      ),
      home: MainPage(),
    );
  }

  _initApp(BuildContext context){
    new DioUtils();
  }
}
