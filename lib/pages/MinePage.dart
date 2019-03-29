import 'package:flutter/material.dart';
import 'BasePage.dart';
import '../Utils/EventBus.dart';

//例子展示，不同widget之间通过事件互相进行通信
//
class MinePage extends BasePage {
  @override
  void initData(BuildContext context) {
    configBar(false, "会员中心", null);
  }

  @override
  Widget buildBody() {
    return Container(
      child: Column(
        children: <Widget>[
          Expanded(
            child: AWidget(),
          ),
          Expanded(
            child: BWidget(),
          ),
        ],
      ),
    );
  }
}

class AWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AWdiget();
}

class _AWdiget extends State<AWidget> {
  String aTip = "Awidget";

  @override
  void initState() {
    super.initState();
    //注册回调
    EventBus().register("AWidgetTip", (arg) => _onTipChange(arg));
  }

  _onTipChange(String tip) {
    setState(() {
      aTip = tip;
    });
  }

  _changeBWidget() {
    EventBus().submit("BWidgetTip", "来自A的点击");
    setState(() {
      aTip = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.pinkAccent,
        child: GestureDetector(
          child: Text("点击，传值给B ${aTip}"),
          onTap: () => _changeBWidget(),
        ));
  }
}

class BWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BWdiget();
}

class _BWdiget extends State<BWidget> {
  String bTip = "Bwidget";

  @override
  void initState() {
    super.initState();
    //注册回调
    EventBus().register("BWidgetTip", (arg) => _onTipChange(arg));
  }

  _onTipChange(String tip) {
    setState(() {
      bTip = tip;
    });
  }

  _changeAWidget() {
    EventBus().submit("AWidgetTip", "来自B的点击");
    setState(() {
      bTip = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: RaisedButton(
          color: Colors.deepOrange,
          onPressed: () => _changeAWidget(),
          child: Text("点击，传值给A ${bTip}"),
        ));
  }
}
