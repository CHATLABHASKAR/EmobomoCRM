import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:dio/dio.dart' as dio;
import '../models/onboarding_model.dart';
import '../services/onboarding_service.dart';

class OnboardingController extends GetxController {
  final box = GetStorage();
  final dio.Dio dioClient = dio.Dio();
  final RxInt step = 0.obs;
  final OnboardingModel model = OnboardingModel();

  // Roles as a map: roleId -> RoleName
  RxMap<String, String> roles = <String, String>{}.obs;
  RxBool loadingRoles = false.obs;
  RxBool isSubmitting = false.obs;

  // Validation
  final formKeys = List.generate(1, (_) => GlobalKey<FormState>());

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
  }

  Future<void> fetchRoles() async {
    loadingRoles.value = true;
    try {
      String companyPk = 'COM#173877631805';
      print("Fetching roles for companyPk: $companyPk");
      final result = await OnboardingService.fetchRoles(companyPk);
      print("Result from fetchRoles: $result");
      roles.value = result;
    } catch (e) {
      print("Error fetching roles: $e");
      Get.snackbar('Error', 'Failed to load roles');
    } finally {
      loadingRoles.value = false;
    }
  }

  void submit() async {
    if (!(formKeys[0].currentState?.validate() ?? false)) {
      Get.snackbar('Error', 'Please fill all required fields');
      return;
    }
    
    formKeys[0].currentState?.save();
    
    // Set companyPk before submission (use the same as in fetchRoles)
    model.companyPk = 'COM#173877631805';
    
    isSubmitting.value = true;
    
    try {
      print("=== ONBOARDING DEBUG ===");
      print("Submitting employee data: ${model.toJson()}");
      print("Token: ${box.read('token')}");
      print("CompanyPk: ${model.companyPk}");
      print("========================");
      
      final response = await OnboardingService.onboardEmployee(model);
      
      print("=== RESPONSE DEBUG ===");
      print("Response: $response");
      print("Status Code: ${response?.statusCode}");
      print("Response Data: ${response?.data}");
      print("======================");
      
      if (response != null && (response.statusCode == 200 || response.statusCode == 201)) {
        if (response.data is Map && response.data['message'] == 'User registered') {
          Get.snackbar(
            'Success', 
            'Employee onboarded successfully!',
            backgroundColor: Colors.green.withOpacity(0.1),
            colorText: Colors.green,
          );
          Get.offAllNamed('/employees');
        } else {
          Get.snackbar(
            'Error', 
            'Onboarding failed: ${response.data is Map ? response.data['message'] ?? 'Unknown error' : 'Invalid response format'}',
            backgroundColor: Colors.red.withOpacity(0.1),
            colorText: Colors.red,
          );
        }
      } else {
        Get.snackbar(
          'Error', 
          'Failed to onboard employee. Status: ${response?.statusCode}. Please try again.',
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
        );
      }
    } catch (e) {
      print("Submission error: $e");
      Get.snackbar(
        'Error', 
        'Submission failed: $e',
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isSubmitting.value = false;
    }
  }
} 