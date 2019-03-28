import 'package:flutter/material.dart';
import 'BasePage.dart';

class TypePage extends BasePage{
  @override
  Widget buildBody() {
    return Container(
      color: Colors.yellowAccent,
      child:  Icon(Icons.search)
    );
  }

  @override
  void initData(BuildContext context) {
    configBar(false,"分类", null);
  }

}