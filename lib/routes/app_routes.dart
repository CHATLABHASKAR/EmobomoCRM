import 'package:crm/screens/dashboard/admin_dashboard.dart';
import 'package:crm/screens/dashboard/sales_dashboard.dart';
import 'package:crm/screens/dashboard/telesales_dashboard.dart';
import 'package:get/get.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/otp_screen.dart';
import '../app/bindings/auth_binding.dart';
import '../screens/onboarding/onboard_employee_screen.dart';
import '../screens/onboarding/employee_list_screen.dart';
import '../screens/onboarding/employee_detail_screen.dart';
import '../screens/customers/customer_list_screen.dart';
import '../screens/customers/customer_form_screen.dart';
import '../screens/customers/customer_detail_screen.dart';
import '../screens/leads/lead_list_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../app/models/employee_model.dart';


final routes = [
  GetPage(name: '/login', page: () => LoginScreen(), binding: AuthBinding()),
  GetPage(name: '/otp', page: () => OtpScreen(), binding: AuthBinding()),
  GetPage(name: '/dashboard/admin', page: () => AdminDashboard()),
  GetPage(name: '/dashboard/sales_exec', page: () => SalesDashboard()),
  GetPage(name: '/dashboard/telesales', page: () => TelesalesDashboard()),
  GetPage(name: '/onboard-employee', page: () => OnboardEmployeeScreen()),
  GetPage(name: '/employees', page: () => EmployeeListScreen()),
  GetPage(name: '/employee-detail', page: () => EmployeeDetailScreen(employee: Get.arguments as EmployeeModel)),
  GetPage(name: '/customers', page: () => CustomerListScreen()),
  GetPage(name: '/customer-form', page: () => CustomerFormScreen()),
  GetPage(name: '/customer-detail', page: () => CustomerDetailScreen(customer: Get.arguments)),
  GetPage(name: '/leads', page: () => LeadListScreen()),
  GetPage(name: '/settings', page: () => SettingsScreen()),
];
