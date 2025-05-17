// ignore_for_file: non_constant_identifier_names
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart' as getx;
import 'package:pos_app/core/network/dio_interceptor.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/utils/constants/rest.dart';
import 'package:requests_inspector/requests_inspector.dart';

enum AppHttpMethod { get, post, put, delete }

final String HTTP_METHOD_GET = 'GET';
final String HTTP_METHOD_POST = 'POST';
final String HTTP_METHOD_PUT = 'PUT';
final String HTTP_METHOD_DELETE = 'DELETE';

class DioClient {
  late final Dio dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: BASE_API_URL,
      connectTimeout: TIMEOUT_DURATION,
      receiveTimeout: TIMEOUT_DURATION,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );
    log("BASE_API_URL : $BASE_API_URL");

    dio = Dio(options);

    dio.interceptors.add(RequestsInspectorInterceptor());
    dio.interceptors.add(RequestsInterceptor());
  }

  Future<ApiResponse<dynamic>> request({
    required String path,
    required AppHttpMethod method,
    Map<String, dynamic>? query,
    dynamic data,
    bool showLoading = false,
  }) async {
    if (method == AppHttpMethod.get) {
      return _execute(() => dio.get(path, queryParameters: query), showLoading: showLoading);
    } else if (method == AppHttpMethod.post) {
      return _execute(() => dio.post(path, data: data), showLoading: showLoading);
    } else if (method == AppHttpMethod.put) {
      return _execute(() => dio.put(path, data: data), showLoading: showLoading);
    } else if (method == AppHttpMethod.delete) {
      return _execute(() => dio.delete(path), showLoading: showLoading);
    }

    return ApiResponse(error: 'Method $method is not supported');
  }

  Future<ApiResponse<T>> _execute<T>(
    Future<Response<T>> Function() requestFunc, {
    bool showLoading = false,
  }) async {
    if (showLoading) {
      await getx.Get.dialog(Center(child: CircularProgressIndicator()), barrierDismissible: false);
    }

    try {
      final response = await requestFunc();

      if (showLoading) getx.Get.back();

      return ApiResponse<T>(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      log("Dio error: $e");

      if (showLoading) getx.Get.back();
      return ApiResponse<T>(
        data: e.response?.data,
        statusCode: e.response?.statusCode,
        error: getErrorMessage(e),
      );
    } catch (e) {
      log("Unexpected error: $e");

      if (showLoading) getx.Get.back();
      return ApiResponse<T>(error: e.toString());
    }
  }

  String getErrorMessage(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Unexpected error occurred: $e';
    }
  }
}
