import 'package:flutter/material.dart';

class LoadingDialog extends Dialog {
  //提示文案
  String text;

  //是否允许被关闭
  bool outsideDismiss;

  LoadingDialog(
      {Key key, @required this.text = "加载中", this.outsideDismiss = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (outsideDismiss) Navigator.of(context).pop();
      },
      child: new Material(
        //创建透明层
        type: MaterialType.transparency, //透明类型
        child: new Center(
          //保证控件居中效果
          child: new SizedBox(
            width: 120.0,
            height: 120.0,
            child: new Container(
              decoration: ShapeDecoration(
                color: Color(0xffffffff),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(8.0),
                  ),
                ),
              ),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                  new Padding(
                    padding: const EdgeInsets.only(
                      top: 20.0,
                    ),
                    child: new Text(
                      text,
                      style: new TextStyle(fontSize: 12.0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  static show(BuildContext context, String loadingTip) {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return LoadingDialog(text: loadingTip);
        });
  }

  dismiss(BuildContext context) {
    Navigator.of(context).pop();
  }
}
