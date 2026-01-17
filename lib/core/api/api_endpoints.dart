class ApiEndpoints {
  // Base URL for the API
// static const String baseUrl = 'http://192.168.1.74:5000';//home wifi 
// static const String baseUrl = 'http://172.25.0.32:5000';//college wifi 
static const String baseUrl = 'http://10.0.2.2:5000';



  // Timeouts
  static const Duration connectionTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth endpoints
 
  static const login = '/api/auth/login';
  static const register = '/api/auth/register';



 
}