import '../Constants/AppLibs.dart';
import 'BasePage.dart';
import '../Net/CategoryPageNet.dart';
import '../model/MainCategory.dart';
import '../model/SubCategory.dart';
import '../model/Goods.dart';
import '../provide/SubCategoryProvide.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

//此页面不同Widget之间的状态共享问题。实现思路
//方案一，通过provide实现。如实现在 左边列表点击时，触发右边的顶部标签栏。
//       需要在main.dart里注册，和vue的State状态管理差不多

//方案二，统一由共同的父级来管理，如右边底部标签栏点击，触发右边下面内容展示

//目前 没有点击左边，不会默认显示右边的内容。正常的情况下，需要进行加载。目前按偷巧的方式解决。见142行

//考虑 增加统一方法注册回调。

class CategoryPage extends BasePage {
  RightContent rightContent;

  onTabSelect(SubCategory subCategory) {
    rightContent.setSelect(subCategory);
  }

  @override
  Widget buildBody() {
    return Container(
        child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        LeftCategoryNav(),
        Expanded(
          child: Column(
            children: <Widget>[
              RightTabNav((value) => onTabSelect(value)),
              Expanded(
                child: rightContent = RightContent(),
              )
            ],
          ),
        )
      ],
    ));
  }

  @override
  void initData(BuildContext context) {
    configBar(false, "分类", null);
  }
}

//左侧导航菜单
class LeftCategoryNav extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _LeftCategoryNav();
}

class _LeftCategoryNav extends State<LeftCategoryNav> {
  List<MainCategory> menuList = [];

  int _selectIndex = 0;

  @override
  void initState() {
    super.initState();

    getCategory().then((dataList) {
      setState(() {
        menuList = dataList;
        _notifyProvide();
      });
    });
  }

  _notifyProvide() {
    List<SubCategory> subNavList = menuList[_selectIndex].bxMallSubDto;
    Provide.value<SubCategoryProvide>(context).getSubCategory(subNavList);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: ScreenUtil.instance.setWidth(180),
      decoration: BoxDecoration(
          border: Border(right: BorderSide(width: 1, color: Colors.black12))),
      child: ListView.builder(
          itemCount: menuList.length,
          itemBuilder: (context, index) {
            return _leftInkWel(index);
          }),
    );
  }

  Widget _leftInkWel(int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectIndex = index;
        });
        _notifyProvide();
      },
      child: Container(
          height: ScreenUtil.instance.setHeight(100),
          padding: EdgeInsets.only(top: 10),
          decoration: BoxDecoration(
              color: _selectIndex == index ? Colors.pink : Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: Center(
            child: Text(
              menuList[index].mallCategoryName,
              style: TextStyle(
                  fontSize: ScreenUtil.instance.setSp(28),
                  color: _selectIndex == index ? Colors.white : Colors.black87),
            ),
          )),
    );
  }
}

//右边状态管理
class RightTabNav extends StatefulWidget {
  final Function callBack;

  RightTabNav(this.callBack);

  @override
  State<StatefulWidget> createState() => _RightTabNav();
}

class _RightTabNav extends State<RightTabNav> {
  int _selectIndex = 0;
  String categoryId = "";

  @override
  Widget build(BuildContext context) {
    return Provide<SubCategoryProvide>(
      builder: (context, child, subCategoryProvide) {
        if (subCategoryProvide.subCategoryList[0].mallCategoryId !=
            categoryId) {
          categoryId = subCategoryProvide.subCategoryList[0].mallCategoryId;
          _selectIndex = 0;
          widget.callBack(subCategoryProvide.subCategoryList[0]);
        }
        return Container(
          height: ScreenUtil.instance.setHeight(80),
          width: ScreenUtil.instance.setWidth(570),
          decoration: BoxDecoration(
              color: Colors.white,
              border:
                  Border(bottom: BorderSide(width: 1, color: Colors.black12))),
          child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: subCategoryProvide.subCategoryList.length,
              itemBuilder: (context, index) {
                return _rightInkWel(
                    subCategoryProvide.subCategoryList[index], index);
              }),
        );
      },
    );
  }

  Widget _rightInkWel(SubCategory category, int index) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectIndex = index;
        });
        widget.callBack(category);
      },
      child: Container(
        padding: EdgeInsets.fromLTRB(5, 10, 5, 10),
        color: _selectIndex == index ? Colors.pinkAccent : Colors.white,
        child: Text(
          category.mallSubName,
          style: TextStyle(
              fontSize: ScreenUtil.instance.setSp(28),
              color: _selectIndex == index ? Colors.white : Colors.black54),
        ),
      ),
    );
  }
}

//右边内容部分
class RightContent extends StatefulWidget {
  _RightContent page;

  setSelect(SubCategory subCategory) {
    page.subCategory = subCategory;
    page.page = 1;
    page.getGoods();
  }

  @override
  State<StatefulWidget> createState() {
    page = _RightContent();
    return page;
  }
}

class _RightContent extends State<RightContent> {
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey =
      new GlobalKey<RefreshFooterState>();

  GlobalKey<RefreshHeaderState> _headerKey =
      new GlobalKey<RefreshHeaderState>();
  SubCategory subCategory;
  int page = 1;
  List<Goods> _goodList = [];

  getGoods() {
    getCategoryGoods(subCategory.mallCategoryId, subCategory.mallSubId, page)
        .then((goodsList) {
      setState(() {
        if (page == 1) {
          _goodList.clear();
        }
        _goodList.addAll(goodsList);
      });
      page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setHeight(1335 - 80),
      child: EasyRefresh(
        key: _easyRefreshKey,
        loadMore: () => getGoods(),
        refreshFooter: ClassicsFooter(
            key: _footerKey,
            bgColor: Colors.white,
            textColor: Colors.pink,
            moreInfoColor: Colors.pink,
            showMore: true,
            noMoreText: '',
            moreInfo: '加载中',
            loadReadyText: '上拉加载....'),
        refreshHeader: ClassicsHeader(
          key: _headerKey,
          bgColor: Colors.white,
          textColor: Colors.pink,
          moreInfoColor: Colors.pink,
          showMore: true,
          refreshedText: "加载中",
          refreshReadyText: "下拉刷新....",
        ),
        child: SingleChildScrollView(child: buildGoods()),
      ),
    );
  }

  Widget buildGoods() {
    double itemWidth = ScreenUtil.instance.setWidth(285);
    return Wrap(
      children: _goodList.map((data) {
        return Container(
          width: itemWidth,
          padding: EdgeInsets.all(5.0),
          color: Colors.white,
          child: Column(
            children: <Widget>[
              Image.network(
                data.image,
                width: itemWidth,
                height: itemWidth,
              ),
              Text(
                data.goodsName,
                style: TextStyle(color: Colors.pink),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "¥ ${data.presentPrice}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "¥ ${data.oriPrice}",
                        style: TextStyle(
                          color: Colors.black38,
                          fontSize: 16,
                          decoration: TextDecoration.lineThrough,
                        ),
                        textAlign: TextAlign.left,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      }).toList(),
    );
  }
}
