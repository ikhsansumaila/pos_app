import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:pos_app/data/repository/utils/response.dart';

abstract class RestClient {
  // final Dio dio;
  // RestClient(this.dio);
  // RestClient()
  //   : dio = Dio(BaseOptions(baseUrl: 'https://your-api.com/api/')) {
  //   dio.interceptors.add(RequestsInspectorInterceptor());
  // Add other interceptors like loggers or error handlers as needed
  // }
  Future<ApiResponse<T>> safeRequest<T>(
    Future<Response> Function() requestFn,
    T Function(dynamic data) fromJson,
  ) async {
    try {
      final response = await requestFn();

      if (response.statusCode == 200 || response.statusCode == 201) {
        return ApiResponse.success(fromJson(response.data));
      } else {
        return ApiResponse.failure('Error status code: ${response.statusCode}');
      }
    } on DioException catch (e) {
      final errorMsg = _handleDioError(e);

      log("dio errorMsg $errorMsg");

      return ApiResponse.failure(errorMsg);
    } catch (e) {
      return ApiResponse.failure('Unknown error: $e');
    }
  }

  String _handleDioError(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Connection timed out';
      case DioExceptionType.badResponse:
        return 'Server error: ${e.response?.statusCode}';
      case DioExceptionType.connectionError:
        return 'No internet connection';
      case DioExceptionType.cancel:
        return 'Request cancelled';
      default:
        return 'Unexpected error occurred';
    }
  }
}
