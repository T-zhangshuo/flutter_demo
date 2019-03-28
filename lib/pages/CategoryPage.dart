import 'package:flutter/material.dart';
import 'BasePage.dart';
import '../Net/CategoryPageNet.dart';

class CategoryPage extends BasePage {

  @override
  Widget buildBody() {
    return Container(
      child: Text("分类"),
    );
  }


  @override
  void initData(BuildContext context) {
    configBar(false, "分类", null);
    getCategory().then((dataList) {
      dataList.forEach((data){
        print("------->"+data.bxMallSubDto[0].mallSubName);
      });
    });
  }
}
