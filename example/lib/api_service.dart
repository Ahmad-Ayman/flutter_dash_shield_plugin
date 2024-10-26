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
      DashShield.applySSLPinning('assets/certificates/fakestoreapi.crt', dio);
      // Future.wait([loadCertificateForSSLPinning()]);
      // HttpClient httpClient = HttpClient(context: securityContext);
      // httpClient.badCertificateCallback =
      //     (X509Certificate cert, String host, int port) {
      //   return false;
      // };
      // (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient =
      //     () => httpClient;

      _instance = ApiService();
    }
    return _instance!;
  }

  // static Future<void> loadCertificateForSSLPinning() async {
  //   final ByteData data =
  //       await rootBundle.load('assets/certificates/fakestoreapi.crt');
  //   SecurityContext secContext = SecurityContext(withTrustedRoots: false);
  //   secContext.setTrustedCertificatesBytes(data.buffer.asUint8List());
  //   securityContext = secContext;
  // }

  Future<Response<dynamic>> get(String uri,
      {bool authorizedApi = false}) async {
    if (kDebugMode) {}
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? 2 : 1,
      'Authorization': authorizedApi
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

  Future<Response<dynamic>> post(
    String uri, {
    bool authorizedApi = false,
    String? body,
    FormData? formDataBody,
  }) async {
    var headers = {
      'Content-Type': 'application/json',
      'AgentType': Platform.isAndroid ? 2 : 1,
      'Authorization': authorizedApi
    };
    if (kDebugMode) {}
    try {
      var data = body ?? formDataBody;
      var res = await dio.post(
        uri,
        data: data,
        options: Options(
          headers: headers,
          responseType: ResponseType.plain,
        ),
      );
      if (kDebugMode) {}

      return res;
    } on DioError catch (ex) {
      throw (ex.response?.data);
    }
  }
}
