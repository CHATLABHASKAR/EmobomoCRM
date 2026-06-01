// lib/app/controllers/customer_controller.dart

import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:get_storage/get_storage.dart';
import '../models/customer_model.dart';
import '../services/customer_service.dart';

class CustomerController extends GetxController {
  final customers = <CustomerModel>[].obs;
  final isLoading = false.obs;
  final error = RxnString();
  final searchQuery = ''.obs;
  final filterCompany = ''.obs;
  final filterCompanyName = ''.obs;

  late final CustomerService _customerService;

  @override
  void onInit() {
    super.onInit();
    _customerService = CustomerService(Dio());
    fetchCustomers();
  }

  Future<void> fetchCustomers() async {
    isLoading.value = true;
    error.value = null;
    try {
      customers.value = await _customerService.fetchCustomers();
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to load customers');
    } finally {
      isLoading.value = false;
    }
  }

  List<CustomerModel> get filteredCustomers {
    List<CustomerModel> list = customers.toList();
    if (searchQuery.value.isNotEmpty) {
      list = list.where((c) =>
        c.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
        c.phone.contains(searchQuery.value) ||
        c.email.toLowerCase().contains(searchQuery.value.toLowerCase())
      ).toList();
    }
    if (filterCompanyName.value.isNotEmpty) {
      list = list.where((c) => c.companyName == filterCompanyName.value).toList();
    }
    return list;
  }

  Future<void> addOrEditCustomer(CustomerModel customer, {bool isEdit = false}) async {
    isLoading.value = true;
    error.value = null;
    bool success = false;
    try {
      if (isEdit) {
        success = await _customerService.updateCustomer(customer);
      } else {
        success = await _customerService.addCustomer(customer);
      }
      if (success) {
        await fetchCustomers();
      } else {
        error.value = 'Failed to save customer';
        Get.snackbar('Error', 'Failed to save customer');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to save customer');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteCustomer(String id) async {
    isLoading.value = true;
    error.value = null;
    try {
      final success = await _customerService.deleteCustomer(id);
      if (success) {
        customers.removeWhere((c) => c.id == id);
      } else {
        error.value = 'Failed to delete customer';
        Get.snackbar('Error', 'Failed to delete customer');
      }
    } catch (e) {
      error.value = e.toString();
      Get.snackbar('Error', 'Failed to delete customer');
    } finally {
      isLoading.value = false;
    }
  }

  void setSearchQuery(String query) {
    searchQuery.value = query;
  }

  void setFilterCompany(String company) {
    filterCompany.value = company;
  }

  void setFilterCompanyName(String companyName) {
    filterCompanyName.value = companyName;
  }

  void clearFilters() {
    searchQuery.value = '';
    filterCompanyName.value = '';
  }
} 