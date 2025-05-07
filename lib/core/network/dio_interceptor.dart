import 'dart:developer';

import 'package:dio/dio.dart';

class RequestsInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // Tambah token kalau perlu
    // options.headers['Authorization'] = 'Bearer your_token';
    return handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    return handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Bisa tambahkan retry / log error
    log('Dio Error: ${err.message}');
    return handler.next(err);
  }
}
