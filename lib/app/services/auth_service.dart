import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';

class AuthService {
  static final Dio _dio = Dio(BaseOptions(
    baseUrl: 'https://gwmrczbpgl.execute-api.ap-south-1.amazonaws.com',
    headers: {'Content-Type': 'application/json'},
  ));

  static final GetStorage _storage = GetStorage();

  /// Login API
static Future<Map<String, dynamic>?> login(String email, String password) async {
  try {
    final response = await _dio.post('/Production/api/user/Login', data: {
      'email': email,
      'password': password,
    });

    if (response.statusCode == 200 && response.data['message'] == 'Login successful') {
      _storage.write('token', response.data['token']);
      _storage.write('user', response.data['user']);
      return response.data; // includes token and user
    }
  } on DioException catch (e) {
    print('Login error: ${e.response?.data ?? e.message}');
  }
  return null;
}


  /// Send OTP to Email
  static Future<bool> sendOtpToEmail(String email) async {
    try {
      final response = await _dio.post('/auth/send-otp', data: {
        'email': email,
      });

      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      print('Send OTP error: ${e.response?.data ?? e.message}');
    }
    return false;
  }

  /// Verify OTP
  static Future<bool> verifyOtp(String session, String code) async {
    try {
      final response = await _dio.post('/auth/verify-otp', data: {
        'session': session,
        'code': code,
      });

      if (response.statusCode == 200) {
        return true;
      }
    } on DioException catch (e) {
      print('Verify OTP error: ${e.response?.data ?? e.message}');
    }
    return false;
  }

  /// Getters for token and user
  static String? getToken() => _storage.read('token');

  static Map<String, dynamic>? getUser() => _storage.read('user');

  /// Logout and clear storage
  static void logout() {
    _storage.erase();
  }
}
