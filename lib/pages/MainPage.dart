import 'package:flutter/material.dart';
import 'BasePage.dart';
import 'HomePage.dart';
import 'TypePage.dart';
import 'ShoppingCartPage.dart';
import 'MinePage.dart';

class MainPage extends BasePage {
  List<BottomNavigationBarItem> _barItemList = List();
  List<Widget> _pageList = List();
  PageController _pageController;
  int _currentIndex = 0;

  @override
  void initData(BuildContext context) {
    _barItemList
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.home),
        title: Text("首页"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.search),
        title: Text("分类"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.shopping_cart),
        title: Text("购物车"),
      ))
      ..add(BottomNavigationBarItem(
        icon: Icon(Icons.trip_origin),
        title: Text("会员中心"),
      ));

    _pageController = PageController();
    _pageList
      ..add(HomePage())
      ..add(TypePage())
      ..add(ShoppingCartPage())
      ..add(MinePage());
  }

  @override
  Widget buildBody() {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: _pageList,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      backgroundColor: Color(0xefefef),
      bottomNavigationBar: BottomNavigationBar(
        items: _barItemList,
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _pageController.animateToPage(index,
                duration: Duration(milliseconds: 200),
                curve: Curves.fastOutSlowIn);
          });
        },
      ),
    );
  }
}
