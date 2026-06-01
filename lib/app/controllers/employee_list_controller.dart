import 'package:get/get.dart';
import '../models/employee_model.dart';
import '../services/employee_service.dart';

class EmployeeListController extends GetxController {
  RxList<EmployeeModel> employees = <EmployeeModel>[].obs;
  RxBool isLoading = false.obs;

  @override
  void onInit() {
    print('EmployeeListController onInit called');
    super.onInit();
    fetchEmployees();
  }

  Future<void> fetchEmployees() async {
    print('fetchEmployees called');
    isLoading.value = true;
    try {
      employees.value = await EmployeeService.fetchEmployees();
    } catch (e, stack) {
      print('❗ Controller error: $e');
      print('❗ Stack trace: $stack');
      Get.snackbar('Error', 'Failed to load employees');
    }
    isLoading.value = false;
  }
} 