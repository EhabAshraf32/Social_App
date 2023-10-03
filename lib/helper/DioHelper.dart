import 'package:dio_helper_flutter/dio_helper.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioHelper {
  Dio dio;

  DioHelper()
      : dio = Dio(BaseOptions(baseUrl: 'https://fcm.googleapis.com/fcm/'));

  Future<Response> getData({
    required String url,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    return await dio.get(
      url,
      queryParameters: query,
    );
  }

  Future<Response> postData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String? to,
  }) async {
    dio.options.headers = {
      'Authorization':
          "key=AAAAjEEcAgE:APA91bHvDYG3Ro9Pginz0ELujlwiFvlCCmJLRSfExzDJb9HFQfgf8E_v1TUqoipsUXiYslyIfz0VDXTM1ipSTfQYUGuqbsrnbCCXk_gNqNUFn3Z9dSn3DL7Xo8MCZ09ggvTpXHAnX73G",
      'Content-Type': 'application/json',
    };

    return dio.post(
      url,
      queryParameters: query,
      data: data,
    );
  }

  Future<Response> putData({
    required String url,
    required Map<String, dynamic> data,
    Map<String, dynamic>? query,
    String lang = 'en',
    String? token,
  }) async {
    dio.options.headers = {
      'lang': lang,
      'Authorization': token ?? '',
      'Content-Type': 'application/json',
    };

    return dio.put(
      url,
      queryParameters: query,
      data: data,
    );
  }
}
