//网络dio相关的配置
//基础访问地址
const String HTTP_BASEURL = "http://test.baixingliangfan.cn/baixing";

//连接超时时间
const int HTTP_TIMEOUT_CONNECT = 5000;
//接收超时时间
const int HTTP_TIMEOUT_RECEIVE = 3000;
//请求参数
const Map<String, dynamic> HTTP_HEADERS = {};
//请求数据类型 (4种): application/x-www-form-urlencoded 、multipart/form-data、application/json、text/xml
const String HTTP_CONTENT_TYPE = "application/x-www-form-urlencoded";
//返回数据类型 (4中): json 、stream 、plain 、bytes
const String HTTP_RECEIVE_TYPE="JSON";


//API 列表
const API={
  //商家首页信息
  "homePageContent":'/wxmini/homePageContent',
  //获取火爆专区的信息
  'homePageBelow':'/wxmini/homePageBelowConten',
  //获取分类
  'category':'/wxmini/getCategory'
};
