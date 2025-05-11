class ApiResponse<T> {
  final T? data;
  final String? error;
  final int? statusCode;

  ApiResponse({this.data, this.error, this.statusCode});

  bool get isSuccess => error == null;

  // final T? data;
  // final String? message;
  // final bool success;

  // ApiResponse({this.data, this.message, required this.success});

  // factory ApiResponse.success(T data) =>
  //     ApiResponse(data: data, success: true);

  // factory ApiResponse.failure(String message) =>
  //     ApiResponse(message: message, success: false);
}
