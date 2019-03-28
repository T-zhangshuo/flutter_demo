import 'package:flutter/material.dart';
import 'BasePage.dart';

class ShoppingCartPage extends BasePage{
  @override
  Widget buildBody() {
    return Container(
      color: Colors.deepOrange,
      child:  Icon(Icons.shopping_cart)
    );
  }

  @override
  void initData(BuildContext context) {
    configBar(false,"购物车", null);
  }

}