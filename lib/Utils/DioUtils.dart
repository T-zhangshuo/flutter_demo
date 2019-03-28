import 'dart:io';
import 'dart:convert' show json;

import 'package:dio/dio.dart';
import 'package:flutter_demo/Net/NetConfig.dart';

//Dio 网络请求库封装，单例模式
class DioUtils {
  Dio _dio;

  void _initHttp() {
    _dio = Dio();
    _dio.options.baseUrl = HTTP_BASEURL;
    _dio.options.connectTimeout = HTTP_TIMEOUT_CONNECT;
    _dio.options.receiveTimeout = HTTP_TIMEOUT_RECEIVE;
    _dio.options.headers = HTTP_HEADERS;
    _dio.options.contentType = ContentType.parse(HTTP_CONTENT_TYPE);
    List<ResponseType> responseTypeList = ResponseType.values;
    responseTypeList.forEach((type) {
      if (type.toString().toLowerCase() == HTTP_RECEIVE_TYPE.toLowerCase()) {
        _dio.options.responseType = type;
      }
    });

    //需要配置自定义的拦截器
    addDataCheckInterceptor();
  }

  void cacheBaseUrl(String baseUrl) {
    _dio.options.baseUrl = baseUrl;
  }

  void configHeaders(Map<String, dynamic> headers) {
    _dio.options.headers.addAll(headers);
  }

  void addDataCheckInterceptor() {
    _dio.interceptors
        .add(InterceptorsWrapper(onRequest: (RequestOptions options) {
      return options;
    }, onResponse: (Response response) {
          Map<String,dynamic> rpData= json.decode(response.toString());
          if(rpData['code']=='0')
            return json.encode(rpData['data']);
          else
            return DioError(message: rpData.toString(),type: DioErrorType.RESPONSE);
    }, onError: (DioError e) {
      return e;
    }));
  }

  Future get(String api, Map<String, dynamic> param) async {
    try {
      Response response = await _dio.get(api, queryParameters: param);
      _printNetdata(api, "GET", param, response.toString());
      return response.toString();
    } catch (e) {
      print(e);
    }
  }

  Future post(String api, Map<String, dynamic> param) async {
    try {
      Response response = await _dio.post(api, queryParameters: param);
      _printNetdata(api, "POST", param, response.toString());
      return response.toString();
    } catch (e) {
      print(e);
    }
  }

  _printNetdata(
      String api, String method, Map<String, dynamic> data, String response) {
    print("URL $method:\t" + _dio.options.baseUrl + api);
    print("param:\t" + data.toString());
//    print("response:\n");
//    int maxLoop = response.length ~/ 200 + (response.length % 200 == 0 ? 0 : 1);
//    for (int i = 0; i < maxLoop; i++) {
//      if (i == (maxLoop - 1))
//        print(response.substring(i * 200));
//      else
//        print(response.substring(i * 200, i * 200 + 200));
//    }
  }

  //单例模式
  factory DioUtils() => getHttp();
  static DioUtils _http;

  DioUtils._internal() {
    //初始化
    _initHttp();
  }

  static DioUtils getHttp() {
    if (_http == null) {
      _http = new DioUtils._internal();
    }
    return _http;
  }
}
