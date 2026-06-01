import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import '../../app/models/employee_model.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/user_avatar.dart';

class EmployeeDetailScreen extends StatelessWidget {
  final EmployeeModel employee;
  const EmployeeDetailScreen({required this.employee, Key? key}) : super(key: key);

  void _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch phone app');
    }
  }

  void _whatsapp(String phone) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleanPhone.startsWith('+') && cleanPhone.length == 10) {
      cleanPhone = '+91$cleanPhone';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp');
    }
  }

  void _gmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 3, // Employees tab index
      role: CrmScaffold.getUserRole(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: UserAvatar(imageUrl: employee.profileImage, radius: 40)),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(employee.fullName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                IconButton(
                  icon: Icon(Icons.edit, color: AppColors.accent),
                  onPressed: () {
                    // Implement edit navigation if needed
                    // Get.toNamed('/onboard-employee', arguments: employee);
                  },
                  tooltip: 'Edit',
                ),
              ],
            ),
            SizedBox(height: 8),
            Text('Email: ${employee.email}'),
            Text('Phone: ${employee.phoneNumber}'),
            if (employee.roleName != null && employee.roleName!.isNotEmpty)
              Text('Role: ${employee.roleName}'),
            if (employee.department != null && employee.department!.isNotEmpty)
              Text('Department: ${employee.department}'),
            if (employee.designation != null && employee.designation!.isNotEmpty)
              Text('Designation: ${employee.designation}'),
            if (employee.joiningDate != null && employee.joiningDate!.isNotEmpty)
              Text('Joining Date: ${employee.joiningDate}'),
            if (employee.location != null && employee.location!.isNotEmpty)
              Text('Location: ${employee.location}'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: AppColors.icon, size: 32),
                  onPressed: () => _call(employee.phoneNumber),
                  tooltip: 'Call',
                ),
                IconButton(
                  icon: Icon(Icons.message, color: AppColors.icon, size: 32),
                  onPressed: () => _whatsapp(employee.phoneNumber),
                  tooltip: 'WhatsApp',
                ),
                IconButton(
                  icon: Icon(Icons.email, color: AppColors.icon, size: 32),
                  onPressed: () => _gmail(employee.email),
                  tooltip: 'Email',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 