import 'package:dio/dio.dart' as dio;
import 'package:get_storage/get_storage.dart';
import '../models/onboarding_model.dart';
import 'dart:convert';

class OnboardingService {
  static final dio.Dio _dio = dio.Dio();
  static final GetStorage _box = GetStorage();

  static String? get token => _box.read('token');

  static dio.Options get _authOptions => dio.Options(
        headers: {'Authorization': 'Bearer $token'},
      );

  static Future<dio.Response?> onboardEmployee(OnboardingModel model) async {
    try {
      print("=== SERVICE DEBUG ===");
      print("Model data: ${model.toJson()}");
      print("Token: $token");
      
      // Check for null values that might cause issues
      final modelData = model.toJson();
      modelData.forEach((key, value) {
        if (value == null) {
          print("⚠️ Null value for field: $key");
        } else if (value.toString().isEmpty) {
          print("⚠️ Empty value for field: $key");
        }
      });
      
      // Ensure all values are strings for FormData
      final safeModelData = <String, String>{};
      modelData.forEach((key, value) {
        safeModelData[key] = value?.toString() ?? '';
      });
      
      // Try a simple test request first
      try {
        print("Testing API endpoint accessibility...");
        final testResponse = await _dio.get(
          'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/user/register',
          options: _authOptions,
        );
        print("API endpoint is accessible: ${testResponse.statusCode}");
      } catch (testError) {
        print("API endpoint test failed: $testError");
      }
      
      final formData = dio.FormData.fromMap(safeModelData);
      print("FormData created successfully");
      print("FormData fields: ${formData.fields}");
      print("=====================");
      
      // Try with minimal required data first
      final minimalData = {
        'firstName': model.firstName ?? '',
        'lastName': model.lastName ?? '',
        'email': model.professionalEmail ?? model.personalEmail ?? '',
        'phoneNumber': model.phoneNumber ?? '',
        'password': model.password ?? '',
        'companyPk': model.companyPk ?? '',
      };
      
      print("Trying with minimal data: $minimalData");
      
      // Try with JSON first, then FormData if needed
      dio.Response response;
      
      try {
        print("Trying with JSON data...");
        response = await _dio.post(
          'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/user/register',
          data: minimalData,
          options: _authOptions.copyWith(contentType: 'application/json'),
        );
        print("JSON request successful");
      } catch (jsonError) {
        print("JSON request failed: $jsonError");
        print("Trying with FormData...");
        response = await _dio.post(
          'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/user/register',
          data: formData,
          options: _authOptions.copyWith(contentType: 'multipart/form-data'),
        );
        print("FormData request successful");
      }
      
      print("=== API RESPONSE ===");
      print("Status Code: ${response.statusCode}");
      print("Response Data: ${response.data}");
      print("Response Data Type: ${response.data.runtimeType}");
      print("===================");
      
      // Handle response data that might be a string
      dynamic responseData = response.data;
      if (responseData is String) {
        try {
          responseData = jsonDecode(responseData);
          print("Decoded response data: $responseData");
        } catch (e) {
          print("Failed to decode response data: $e");
        }
      }
      
      if ((response.statusCode == 200 || response.statusCode == 201) && responseData is Map && responseData['message'] == 'User registered') {
        print("✅ Onboarding Success: "+responseData['message']);
        print("✅ User created with ID: ${responseData['user']?['SK'] ?? 'Unknown'}");
        return response;
      } else {
        print("❌ Onboarding failed with status: ${response.statusCode}");
        print("❌ Response message: ${responseData is Map ? responseData['message'] : 'Invalid response format'}");
        print("❌ Response data type: ${responseData.runtimeType}");
        return response;
      }
    } on dio.DioException catch (e) {
      print("=== DIO EXCEPTION ===");
      print("Exception type: ${e.type}");
      print("Exception message: ${e.message}");
      if (e.response != null) {
        print("Status Code: ${e.response?.statusCode ?? 'unknown'}");
        print("Error Data: ${e.response?.data ?? 'no data'}");
        print("Error Headers: ${e.response?.headers}");
      } else {
        print("No response data available");
      }
      print("====================");
      return e.response;
    } catch (e) {
      print("❗ Unexpected Error: $e");
      return null;
    }
  }

  /// Fetch roles from the real API endpoint
  static Future<Map<String, String>> fetchRoles(String companyPk) async {
    try {
      final res = await _dio.get(
        'https://sg91d8kwla.execute-api.ap-south-1.amazonaws.com/Prod/api/user/roles-dropdown',
        queryParameters: {'companyPk': companyPk},
        options: _authOptions,
      );
      print("Roles API raw response: ${res.data}");
      var data = res.data;
      if (data is String) {
        data = jsonDecode(data);
      }
      if (data is List) {
        final roles = {
          for (var role in data)
            role['roleId']?.toString() ?? '': role['RoleName']?.toString() ?? ''
        };
        print("✅ Parsed roles: $roles");
        return roles;
      } else {
        print("❌ Unexpected response type: "+data.runtimeType.toString());
        return {};
      }
    } catch (e) {
      print("❗ Error fetching roles: $e");
      return {};
    }
  }
}
