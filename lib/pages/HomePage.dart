import '../Constants/AppLibs.dart';
import 'BasePage.dart';
import '../Net/HomePageNet.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends BasePage {
  @override
  void initData(BuildContext context) {
    super.initData(context);
    configBar(false, "首页", null);
  }

  @override
  Widget buildBody() {
    return FutureBuilder(
      future: getHomePageContent(context),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = json.decode(snapshot.data.toString());
          List<Map> swiperDataList = (data['slides'] as List).cast();
          List<Map> menuList = (data['category'] as List).cast();
          String adPicture = data['advertesPicture']['PICTURE_ADDRESS'];
          String shopInfo = data['shopInfo']['leaderImage'];
          String shopPhone = data['shopInfo']['leaderPhone'];
          List<Map> recommendList=(data['recommend'] as List).cast();

          return SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SwiperDiy(
                  swiperDataList: swiperDataList,
                ),
                MenuGridView(menuList),
                ImgBanner(adPicture, () {}),
                ImgBanner(shopInfo, () {
                  _launchURL(shopPhone);
                }),
                Recommend(recommendList),
              ],
            ),
          );
        } else {
          return Center(
            child: Text("加载中"),
          );
        }
      },
    );
  }

  _launchURL(String shopPhone) async {
    String url = 'tel:' + shopPhone;
    print(url);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      print("不能拨打电话");
    }
  }
}

//首页顶部栏滚动
class SwiperDiy extends StatelessWidget {
  final List swiperDataList;

  SwiperDiy({Key key, this.swiperDataList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: ScreenUtil.instance.setHeight(330),
      child: Swiper(
        itemCount: swiperDataList.length,
        itemBuilder: (BuildContext context, int index) {
          String imgPath = swiperDataList[index]['image'];
          return Image.network(
            imgPath,
            fit: BoxFit.fill,
          );
        },
        pagination: new SwiperPagination(),
        autoplay: true,
      ),
    );
  }
}

//菜单栏目
class MenuGridView extends StatelessWidget {
  final List menuList;

  MenuGridView(this.menuList);

  Widget _gridViewItemUI(BuildContext context, item) {
    return InkWell(
      onTap: () {
        print('点击了导航');
      },
      child: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(5)),
        child: Column(
          children: <Widget>[
            Image.network(item['image'], width: ScreenUtil().setWidth(85)),
            Text(item['mallCategoryName'])
          ],
        ),
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (menuList.length > 10) {
      this.menuList.removeRange(10, menuList.length);
    }
    return Container(
      height: ScreenUtil.instance.setHeight(330),
      child: GridView.count(
        crossAxisCount: 5,
        children: menuList.map((item) {
          return _gridViewItemUI(context, item);
        }).toList(),
      ),
    );
  }
}

//图片广告
class ImgBanner extends StatelessWidget {
  final String adPicture;
  GestureTapCallback onTapFunction;

  ImgBanner(this.adPicture, this.onTapFunction);

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
        child: InkWell(
          onTap: onTapFunction,
          child: Image.network(adPicture),
        ));
  }
}

//商品推荐
class Recommend extends StatelessWidget {
  final List recommendList;

  Recommend(this.recommendList);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        _buildTitle(),
        _buildList()
      ],
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 1.0, 0, 5.0),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border:
              Border(bottom: BorderSide(width: 1, color: Colors.black12))),
      child: Text(
        '商品推荐',
        style: TextStyle(color: Colors.pink),
      ),
    );
  }

  Widget _buildItem(int index) {
    return InkWell(
      onTap: () {},
      child: Container(
        height: ScreenUtil.instance.setHeight(330),
        width: ScreenUtil.instance.setWidth(250),
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
            color: Colors.white,
            border:
                Border(left: BorderSide(width: 1, color: Colors.black12))),
        child: Column(
          children: <Widget>[
            Image.network(recommendList[index]['image']),
            Text(
              '¥ ${recommendList[index]['price']}',
              style: TextStyle(
                  decoration: TextDecoration.lineThrough, color: Colors.grey),
            ),
            Text(
              '¥ ${recommendList[index]['mallPrice']}',
              style: TextStyle(
                color: Colors.pink
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildList() {
    return Container(
      height: ScreenUtil.instance.setHeight(330),
      child: ListView.builder(
        itemBuilder: (context, index) {
          return _buildItem(index);
        },
        scrollDirection: Axis.horizontal,
        itemCount: recommendList.length,
      ),
    );
  }
}
