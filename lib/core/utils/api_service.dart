import 'dart:developer';

import 'package:dio/dio.dart';

class ApiService {
  Dio dio = Dio();

  Future<Response> post(
      {required body,
      required String url,
      String? token,
      String? contentType,
      Map<String, String>? headers}) async {
    log("service called $url");
    log("service called $body");
    log("service called $contentType");
    log("service called $token");
    log("service called $headers");

    var response = await dio.post(
      url,
      data: body,
      options: Options(
        headers: headers ??
            {
              'Content-Type': contentType,
              'Authorization': 'Bearer $token',
            },
      ),
    );
    log("message");

    return response;
  }
}
