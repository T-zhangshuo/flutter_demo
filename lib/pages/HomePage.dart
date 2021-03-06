import '../Constants/AppLibs.dart';
import 'BasePage.dart';
import '../Net/HomePageNet.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class HomePage extends BasePage {
  int _page = 0;
  List<Map> _hotGoodsList = List();
  GlobalKey<EasyRefreshState> _easyRefreshKey =
      new GlobalKey<EasyRefreshState>();
  GlobalKey<RefreshFooterState> _footerKey = new GlobalKey<RefreshFooterState>();

  @override
  void initData(BuildContext context) {
    super.initData(context);
    configBar(false, "首页", null);
  }

  _getGoodsList() async {
    getHomePageBelow(_page).then((data) {
      setState(() {
        if (_page == 0) {
          _hotGoodsList.clear();
        }
        _hotGoodsList.addAll((json.decode(data) as List).cast());
      });
      _page++;
    });
  }

  @override
  Widget buildBody() {
    return FutureBuilder(
      future: getHomePageContent(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var data = json.decode(snapshot.data.toString());
          List<Map> swiperDataList = (data['slides'] as List).cast();
          List<Map> menuList = (data['category'] as List).cast();
          String adPicture = data['advertesPicture']['PICTURE_ADDRESS'];
          String shopInfo = data['shopInfo']['leaderImage'];
          String shopPhone = data['shopInfo']['leaderPhone'];
          List<Map> tmpList = (data['recommend'] as List).cast();
          //模拟横行条滚动，多增加一组数据
          List<Map> recommendList = List();
          recommendList.addAll(tmpList);
          recommendList.addAll(tmpList);

          //楼层内容
          String pic_title = data['floor1Pic']['PICTURE_ADDRESS'];
          List<Map> floorList = (data['floor1'] as List).cast();

          return EasyRefresh(
            key: _easyRefreshKey,
            loadMore: () => _getGoodsList(),
            refreshFooter: ClassicsFooter(
                key:_footerKey,
                bgColor:Colors.white,
                textColor: Colors.pink,
                moreInfoColor: Colors.pink,
                showMore: true,
                noMoreText: '',
                moreInfo: '加载中',
                loadReadyText:'上拉加载....'
            ),
            child: SingleChildScrollView(
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
                  Floor(
                    pic_title,
                    floorList[0]['image'],
                    floorList[1]['image'],
                    floorList[2]['image'],
                    floorList[3]['image'],
                    floorList[4]['image'],
                  ),
                  HotGoods(_hotGoodsList)
                ],
              ),
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
        physics: NeverScrollableScrollPhysics(),
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
      children: <Widget>[_buildTitle(), _buildList()],
    );
  }

  Widget _buildTitle() {
    return Container(
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.fromLTRB(10.0, 1.0, 0, 5.0),
      margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          border: Border(bottom: BorderSide(width: 1, color: Colors.black12))),
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
            border: Border(left: BorderSide(width: 1, color: Colors.black12))),
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
              style: TextStyle(color: Colors.pink),
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

//楼层 (与教程不一致）
class Floor extends StatelessWidget {
  String picture_title;
  String picture_left1;
  String picture_left2;

  String picture_right1;
  String picture_right2;
  String picture_right3;

  Floor(this.picture_title, this.picture_left1, this.picture_left2,
      this.picture_right1, this.picture_right2, this.picture_right3);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[_buildTitle(), _buildRow()],
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Image.network(picture_title),
    );
  }

  Widget _buildRow() {
    return Container(
      height: ScreenUtil.instance.setHeight(600),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Image.network(
                  picture_left1,
                  height: ScreenUtil.instance.setHeight(400),
                  fit: BoxFit.fill,
                ),
                Image.network(
                  picture_left2,
                  height: ScreenUtil.instance.setHeight(200),
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Column(
              children: <Widget>[
                Image.network(
                  picture_right1,
                  height: ScreenUtil.instance.setHeight(200),
                  fit: BoxFit.fill,
                ),
                Image.network(
                  picture_right2,
                  height: ScreenUtil.instance.setHeight(200),
                  fit: BoxFit.fill,
                ),
                Image.network(
                  picture_right3,
                  height: ScreenUtil.instance.setHeight(200),
                  fit: BoxFit.fill,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

//火爆专区
class HotGoods extends StatefulWidget {
  List<Map> _hotGoodsList;

  HotGoods(this._hotGoodsList);

  @override
  State<StatefulWidget> createState() => _HotGoodsState();
}

class _HotGoodsState extends State<HotGoods> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[buildTile(), buildGoods()],
    );
  }

  Widget buildTile() {
    return Text(
      "火爆专区",
      textAlign: TextAlign.center,
      style: TextStyle(fontSize: 16, color: Colors.redAccent),
    );
  }

  Widget buildGoods() {
    double itemWidth = ScreenUtil.instance.setWidth(375);
    return Wrap(
      children: widget._hotGoodsList.map((data) {
        return Container(
          width: itemWidth,
          child: Column(
            children: <Widget>[
              Image.network(
                data['image'],
                width: itemWidth,
                height: itemWidth,
              ),
              Text(
                data['name'],
                style: TextStyle(color: Colors.pink),
              ),
              Padding(
                padding: EdgeInsets.all(5.0),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Text(
                        "¥ ${data['mallPrice']}",
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        textAlign: TextAlign.left,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        "¥ ${data['price']}",
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
