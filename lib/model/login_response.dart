class LoginResponse {
  final int code;
  final String message;
  final Map<String, dynamic> data;

  LoginResponse({
    required this.code,
    required this.message,
    required this.data,
  });
}
