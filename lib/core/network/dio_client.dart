import 'package:dio/dio.dart';
import 'package:pos_app/core/network/dio_interceptor.dart';
import 'package:pos_app/core/network/response.dart';
import 'package:pos_app/utils/constants/rest.dart';
import 'package:requests_inspector/requests_inspector.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: BASE_API_URL,
      connectTimeout: TIMEOUT_DURATION,
      receiveTimeout: TIMEOUT_DURATION,
      headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
    );

    dio = Dio(options);

    dio.interceptors.add(RequestsInspectorInterceptor());
    dio.interceptors.add(RequestsInterceptor());
  }

  Future<ApiResponse<dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    try {
      final response = await dio.get(path, queryParameters: query);
      // log("response.data dari dio client : ${response.data}");
      return ApiResponse(data: response.data, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse(
        data: e.response,
        error: getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<dynamic>> post(String path, {dynamic data}) async {
    try {
      final response = await dio.post(path, data: data);
      return ApiResponse(data: response, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse(
        data: e.response,
        error: getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<dynamic>> put(String path, {dynamic data}) async {
    try {
      final response = await dio.put(path, data: data);
      return ApiResponse(data: response, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse(
        data: e.response,
        error: getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
    }
  }

  Future<ApiResponse<dynamic>> delete(String path) async {
    try {
      final response = await dio.delete(path);
      return ApiResponse(data: response, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse(
        data: e.response,
        error: getErrorMessage(e),
        statusCode: e.response?.statusCode,
      );
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
