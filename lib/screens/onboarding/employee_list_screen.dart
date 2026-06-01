import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get_storage/get_storage.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import '../../app/controllers/employee_list_controller.dart';
import 'dart:ui';
import 'package:flutter_animate/flutter_animate.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/neon_glass_container.dart';
import '../../app/widgets/user_avatar.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'onboard_employee_screen.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  State<EmployeeListScreen> createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> {
  final EmployeeListController controller = Get.put(EmployeeListController());
  final GetStorage _box = GetStorage();
  int _currentIndex = 3; // Default, will be set in initState

  String filterQuery = '';
  final TextEditingController _searchController = TextEditingController();

  String get userRole {
    final userData = _box.read('user');
    if (userData != null && userData is Map) {
      return userData['role'] ?? userData['user']?['role'] ?? 'admin';
    }
    return 'admin';
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = userRole == 'admin' ? 3 : 2;
    controller.fetchEmployees();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Ensure correct tab is selected when navigating to /employees
    final currentRoute = ModalRoute.of(context)?.settings.name;
    if (userRole == 'admin' && currentRoute == '/employees') {
      setState(() {
        _currentIndex = 3;
      });
    }
  }

  void _call(String phone) async {
    try {
      // Clean phone number (remove spaces, dashes, etc.)
      String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      
      final uri = Uri(scheme: 'tel', path: cleanPhone);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri);
      } else {
        Get.snackbar(
          'Error',
          'Could not launch phone app',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColors.errorBackground,
          colorText: AppColors.errorText,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to make call: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorBackground,
        colorText: AppColors.errorText,
      );
    }
  }

  void _whatsapp(String phone) async {
    try {
      print('WhatsApp - Original phone: $phone');
      
      // Clean phone number and ensure it has country code
      String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
      print('WhatsApp - Cleaned phone: $cleanPhone');
      
      // If phone doesn't start with +, assume it's Indian number and add +91
      if (!cleanPhone.startsWith('+')) {
        if (cleanPhone.startsWith('0')) {
          cleanPhone = '+91' + cleanPhone.substring(1);
        } else if (cleanPhone.length == 10) {
          cleanPhone = '+91' + cleanPhone;
        }
      }
      
      print('WhatsApp - Final phone: $cleanPhone');
      
      // Try multiple WhatsApp URL schemes
      List<String> whatsappUrls = [
        'https://wa.me/$cleanPhone',
        'whatsapp://send?phone=$cleanPhone',
        'https://api.whatsapp.com/send?phone=$cleanPhone',
      ];
      
      bool launched = false;
      
      for (String url in whatsappUrls) {
        try {
          final uri = Uri.parse(url);
          print('WhatsApp - Trying URI: $uri');
          
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          print('WhatsApp - Launched successfully');
          launched = true;
          break;
        } catch (e) {
          print('WhatsApp - Failed to launch: $url - Error: $e');
          continue;
        }
      }
      
      if (!launched) {
        print('WhatsApp - All URLs failed, offering clipboard option');
        // Show dialog to copy phone number to clipboard
        Get.dialog(
          AlertDialog(
            title: Text('WhatsApp Not Available', style: TextStyle(color: AppColors.text)),
            content: Text('WhatsApp is not installed or cannot be opened. Would you like to copy the phone number to clipboard?', style: TextStyle(color: AppColors.text)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: AppColors.text)),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: cleanPhone));
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Phone number copied to clipboard: $cleanPhone',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.successBackground,
                    colorText: AppColors.successText,
                  );
                },
                child: Text('Copy', style: TextStyle(color: AppColors.text)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('WhatsApp - Error: $e');
      Get.snackbar(
        'Error',
        'Failed to open WhatsApp: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorBackground,
        colorText: AppColors.errorText,
      );
    }
  }

  void _gmail(String email) async {
    try {
      print('Email - Original email: $email');
      
      // Get current user's email from storage
      final userData = _box.read('user');
      String fromEmail = 'noreply@company.com'; // Default fallback
      
      if (userData != null && userData is Map) {
        // Check if userData has a nested 'user' object (from UserModel structure)
        if (userData['user'] != null && userData['user'] is Map) {
          fromEmail = userData['user']['email'] ?? fromEmail;
        } else {
          // Direct email field (fallback)
          fromEmail = userData['email'] ?? fromEmail;
        }
      }
      
      print('Email - Using from email: $fromEmail');
      
      // Try multiple email URL schemes
      List<String> emailUrls = [
        'mailto:$email?subject=${Uri.encodeComponent('Hello from CRM')}&body=${Uri.encodeComponent('Hi, I hope this email finds you well.')}',
        'mailto:$email',
      ];
      
      bool launched = false;
      
      for (String url in emailUrls) {
        try {
          final uri = Uri.parse(url);
          print('Email - Trying URI: $uri');
          
          await launchUrl(uri);
          print('Email - Launched successfully');
          launched = true;
          break;
        } catch (e) {
          print('Email - Failed to launch: $url - Error: $e');
          continue;
        }
      }
      
      if (!launched) {
        print('Email - All URLs failed, offering clipboard option');
        // Show dialog to copy email to clipboard
        Get.dialog(
          AlertDialog(
            title: Text('Email App Not Available', style: TextStyle(color: AppColors.text)),
            content: Text('No email app is installed or cannot be opened. Would you like to copy the email address to clipboard?', style: TextStyle(color: AppColors.text)),
            actions: [
              TextButton(
                onPressed: () => Get.back(),
                child: Text('Cancel', style: TextStyle(color: AppColors.text)),
              ),
              TextButton(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: email));
                  Get.back();
                  Get.snackbar(
                    'Success',
                    'Email copied to clipboard: $email',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: AppColors.successBackground,
                    colorText: AppColors.successText,
                  );
                },
                child: Text('Copy', style: TextStyle(color: AppColors.text)),
              ),
            ],
          ),
        );
      }
    } catch (e) {
      print('Email - Error: $e');
      Get.snackbar(
        'Error',
        'Failed to open email: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.errorBackground,
        colorText: AppColors.errorText,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 3, // Employees tab index
      role: CrmScaffold.getUserRole(),
      child: Obx(() {
        final employees = controller.employees;
        final filteredEmployees = employees.where((employee) {
          final query = filterQuery.toLowerCase();
          return employee.fullName.toLowerCase().contains(query) ||
                 (employee.email?.toLowerCase().contains(query) ?? false) ||
                 (employee.roleName?.toLowerCase().contains(query) ?? false);
        }).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Employees',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Add Employee'),
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: OnboardEmployeeScreen(),
                      ),
                    );
                    if (result != null) {
                      controller.fetchEmployees();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or role',
                  prefixIcon: Icon(Icons.search, color: AppColors.icon),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: AppColors.glass,
                ),
                onChanged: (value) {
                  setState(() {
                    filterQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: filteredEmployees.isEmpty
                  ? Center(child: Text('No employees found.', style: TextStyle(color: AppColors.text)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredEmployees.length,
                      itemBuilder: (context, index) {
                        final employee = filteredEmployees[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.toNamed('/employee-detail', arguments: employee);
                            },
                            child: NeonGlassContainer(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              borderRadius: BorderRadius.circular(20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      UserAvatar(imageUrl: employee.profileImage, radius: 28),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(employee.fullName, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 18)),
                                            SizedBox(height: 2),
                                            Text('Email: ${employee.email}', style: TextStyle(color: AppColors.text.withOpacity(0.8), fontSize: 14)),
                                            Text('Phone: ${employee.phoneNumber}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
                                            if (employee.roleName != null)
                                              Text('Role: ${employee.roleName}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
                                          ],
                                        ),
                                      ),
                                      Icon(Icons.chevron_right, color: AppColors.icon, size: 28),
                                    ],
                                  ),
                                  SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.call, color: AppColors.icon, size: 28),
                                        onPressed: () {
                                          final uri = Uri(scheme: 'tel', path: employee.phoneNumber);
                                          launchUrl(uri);
                                        },
                                        tooltip: 'Call',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.message, color: AppColors.icon, size: 28),
                                        onPressed: () {
                                          String cleanPhone = employee.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
                                          if (!cleanPhone.startsWith('+') && cleanPhone.length == 10) {
                                            cleanPhone = '+91$cleanPhone';
                                          }
                                          final uri = Uri.parse('https://wa.me/$cleanPhone');
                                          launchUrl(uri, mode: LaunchMode.externalApplication);
                                        },
                                        tooltip: 'WhatsApp',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.email, color: AppColors.icon, size: 28),
                                        onPressed: () {
                                          final uri = Uri(scheme: 'mailto', path: employee.email);
                                          launchUrl(uri);
                                        },
                                        tooltip: 'Email',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
} 