class BaseResponse {
  final int code;
  final String message;
  final Map<String, dynamic>? data;

  BaseResponse({
    required this.code,
    required this.message,
    required this.data,
  });
}
