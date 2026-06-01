// ignore_for_file: unused_local_variable

import 'package:get/get.dart';
import '../services/auth_service.dart';
import '../models/user_model.dart';
import 'package:get_storage/get_storage.dart';

class AuthController extends GetxController {
  final box = GetStorage();

  var isLoading = false.obs;
  var email = ''.obs;
  var password = ''.obs;
  var session = ''.obs; // OTP session
  var isPasswordLogin = true.obs;

  /// Login using email & password
  Future<void> login() async {
    isLoading(true);
    try {
      final res = await AuthService.login(email.value, password.value);
      print('responseData: $res');
      if (res != null) {
        _saveUser(res); // Always log in directly
      } else {
        Get.snackbar("Error", "Invalid email or password");
      }
    } catch (e) {
      print('Login error: $e');
      Get.snackbar("Error", "Login failed");
    } finally {
      isLoading(false);
    }
  }


  /// Verify OTP
  Future<void> verifyOtp(String code) async {
    isLoading(true);
    try {
      bool success = await AuthService.verifyOtp(session.value, code);
      if (success) {
        final userData = AuthService.getUser();
        final token = AuthService.getToken();
        if (userData != null) {
          _saveUser(userData);
        } else {
          Get.snackbar("Error", "User data missing after OTP");
        }
      } else {
        Get.snackbar("Error", "Invalid OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "OTP verification failed");
    } finally {
      isLoading(false);
    }
  }

  /// Send OTP only (without password login)
  Future<void> sendOtpOnly() async {
    isLoading(true);
    try {
      bool success = await AuthService.sendOtpToEmail(email.value);
      if (success) {
        // Assume server sends session ID via storage or direct response
        session.value = AuthService.getUser()?['session'] ?? '';
        Get.toNamed('/otp');
      } else {
        Get.snackbar("Error", "Failed to send OTP");
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to send OTP");
    } finally {
      isLoading(false);
    }
  }

  /// Save user data and navigate to dashboard
  void _saveUser(Map<String, dynamic> data) {
    print('[_saveUser] data: ' + data.toString());
    final user = UserModel.fromJson(data);
    print('[_saveUser] user: ' + user.toString());
    String role = (user.role ?? 'admin').toLowerCase();
    // Map backend roles to frontend dashboard roles
   if (role == 'insidesales') {
    role = 'telesales';
  } else if (role == 'salesexecutive') {
    role = 'sales_exec';
  }
    box.write('token', user.token ?? '');
    print('[_saveUser] token written');
    box.write('role', role);
    print('[_saveUser] role written');
    box.write('user', data);
    print('[_saveUser] user written to box');
    // Navigate to dashboard based on user role
    print('[_saveUser] navigating to /dashboard/ [32m$role [0m');
    Get.offAllNamed('/dashboard/$role');
  }
}
