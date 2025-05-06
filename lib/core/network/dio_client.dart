import 'package:dio/dio.dart';
import 'package:pos_app/core/network/dio_interceptor.dart';
import 'package:pos_app/utils/constants/constant.dart';
import 'package:requests_inspector/requests_inspector.dart';

class DioClient {
  late final Dio dio;

  DioClient() {
    final options = BaseOptions(
      baseUrl: BASE_API_URL,
      connectTimeout: TIMEOUT_DURATION,
      receiveTimeout: TIMEOUT_DURATION,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    );

    dio = Dio(options);

    // Interceptor untuk logging / error handling
    dio.interceptors.add(RequestsInspectorInterceptor());
    dio.interceptors.add(RequestsInterceptor());
  }

  Future<Response> get(String path, {Map<String, dynamic>? query}) async {
    return await dio.get(path, queryParameters: query);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }

  String getErrorMessage(DioException e) {
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
        return 'Unexpected error occurred: $e';
    }
  }
}
