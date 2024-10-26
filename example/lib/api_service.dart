import 'dart:io';

import 'package:dash_shield/dash_shield.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  static Dio dio = Dio();
  static ApiService? _instance;
  static SecurityContext? securityContext;

  static ApiService getInstance() {
    if (_instance == null) {
      BaseOptions options = BaseOptions(
        receiveDataWhenStatusError: true,
        connectTimeout: const Duration(seconds: 10),
      );
      dio.options = options;
      Future.wait([
        DashShield.applySSLPinning(['assets/my_cert.crt'], dio)
      ]);

      _instance = ApiService();
    }
    return _instance!;
  }

  Future<Response<dynamic>> get(String uri,
      {bool authorizedApi = false}) async {
    if (kDebugMode) {}
    var headers = {
      'Content-Type': 'application/json',
    };

    try {
      var res = await dio.get(
        uri,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
        ),
      );

      return res;
    } on DioException catch (ex) {
      throw (ex.response?.data);
    }
  }
}
