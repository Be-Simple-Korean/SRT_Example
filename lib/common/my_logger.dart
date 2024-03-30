import 'package:logger/web.dart';

/// 로거 싱글톤
class MyLogger {
  static final MyLogger _instance = MyLogger._internal();
  final Logger _logger = Logger();

  factory MyLogger() {
    return _instance;
  }

  MyLogger._internal();

  void d(String msg){
    _logger.d(msg);
  }

  void i(String msg){
    _logger.i(msg);
  }

  void e(String msg){
    _logger.e(msg);
  }

}
