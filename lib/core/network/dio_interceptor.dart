import 'dart:developer';

import 'package:dio/dio.dart';

class RequestsInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('\r\n');
    log('--> REQUEST ${options.method.toUpperCase()} ${'${options.baseUrl}${options.path}'}');
    log('\r\n');
    log('============ HEADERS ============');
    options.headers.forEach((k, dynamic v) => log('$k: $v'));
    log('\r\n');
    log('======== QUERY PARAMETERS ========');
    options.queryParameters.forEach((k, dynamic v) => log('$k: $v'));
    if (options.data != null) {
      log('Body: ${options.data}');
    }
    log('\r\n');
    log('--> REQUEST END ${options.method.toUpperCase()}');

    super.onRequest(options, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log('\r\n');
    log('<-- ${err.message} ${err.response != null ? err.response!.realUri.path : 'Unknown Path'}');
    log('${err.response != null ? err.response!.data : 'Unknown Error'}');
    log('<-- End error');

    super.onError(err, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    log('\r\n');
    log('<--- RESPONSE HTTP CODE : ${response.statusCode} URL : ${response.realUri.path}');
    log('Data: ${response.data}');
    log('<--- RESPONSE END HTTP');
    log('\r\n');

    super.onResponse(response, handler);
  }
}
