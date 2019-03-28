import 'package:flutter/material.dart';
import 'BasePage.dart';

class MinePage extends BasePage{
  @override
  void initData(BuildContext context) {
    configBar(false, "会员中心", null);
  }

  @override
  Widget buildBody() {
    return Container(
      color: Colors.deepOrange,
      child:  Icon(Icons.print)
    );
  }



}