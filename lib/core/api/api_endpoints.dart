import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiEndpoints {
  static const bool isPhysicalDevice = false;
  static const String _ipAddress = '192.168.1.11'; // change for physical device home
  //  static const String _ipAddress = "192.168.100.193";
  static const int _port = 5000;

  static String get _host {
    if (isPhysicalDevice) return _ipAddress;
    if (kIsWeb) return 'localhost';
    if (Platform.isAndroid) return '10.0.2.2';
    if (Platform.isIOS) return 'localhost';
    return 'localhost';
  }

  static String get baseUrl => 'http://$_host:$_port';

  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
  static const String login = '/api/auth/login';
  static const String register = '/api/auth/register';
  static const String whoAmI = '/api/auth/whoami';
  static const String updateProfile = '/api/auth/update-profile';
  

  // Pizza endpoints
  static const String pizzas = '/api/pizzas';

  // Order endpoints
  static const String orders = '/api/orders';
  static String ordersMy() => '$orders/my';
  static String orderCancel(String id) => '$orders/$id/cancel';
}
