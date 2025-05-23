import 'dart:convert';
import 'dart:developer';

class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({this.data, this.error, this.statusCode});

  bool get isError => error != null || (statusCode != null && statusCode! >= 300);
  bool get isSuccess => !isError;

  @override
  String toString() {
    log("statusCode: $statusCode");
    try {
      return jsonEncode({'statusCode': statusCode, 'error': error, 'data': data});
    } catch (e) {
      return 'statusCode: $statusCode, error: $error, data: ${data.toString()}';
    }
  }

  // final T? data;
  // final String? message;
  // final bool success;

  // ApiResponse({this.data, this.message, required this.success});

  // factory ApiResponse.success(T data) =>
  //     ApiResponse(data: data, success: true);

  // factory ApiResponse.failure(String message) =>
  //     ApiResponse(message: message, success: false);
}
