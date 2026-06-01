import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../app/controllers/customer_controller.dart';
import '../../app/models/customer_model.dart';
import 'customer_detail_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/widgets/neon_glass_container.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/app_bottom_nav_bar.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/widgets/user_avatar.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'package:flutter/widgets.dart';
import 'customer_form_screen.dart';

class CustomerListScreen extends StatefulWidget {
  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  final CustomerController controller = Get.put(CustomerController());
  final GetStorage _box = GetStorage();
  int _currentIndex = 2; // Customers tab index for all roles
  String filterQuery = '';
  final TextEditingController _searchController = TextEditingController();

  String get userRole {
    final userData = _box.read('user');
    if (userData != null && userData is Map) {
      return userData['role'] ?? userData['user']?['role'] ?? 'admin';
    }
    return 'admin';
  }

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
      currentIndex: 2, // Customers tab index
      role: CrmScaffold.getUserRole(),
      child: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.error.value != null) {
          return Center(child: Text('Error: ${controller.error.value}', style: TextStyle(color: AppColors.error)));
        }
        final customers = controller.customers;
        final filteredCustomers = customers.where((customer) {
          final query = filterQuery.toLowerCase();
          return (customer.companyName?.toLowerCase() ?? '').contains(query) ||
                 (customer.contactName?.toLowerCase() ?? '').contains(query) ||
                 (customer.phone?.toLowerCase() ?? '').contains(query);
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
                      'Customers',
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
                  label: Text('Add Customer'),
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: CustomerFormScreen(),
                      ),
                    );
                    if (result != null) {
                      controller.fetchCustomers();
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
                  hintText: 'Search by name, email, or company',
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
              child: filteredCustomers.isEmpty
                  ? Center(child: Text('No customers found.', style: TextStyle(color: AppColors.text)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredCustomers.length,
                      itemBuilder: (context, index) {
                        final customer = filteredCustomers[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => CustomerDetailScreen(customer: customer));
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
                                      UserAvatar(imageUrl: customer.profileImage, radius: 28),
                                      SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(customer.contactName, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 18)),
                                            SizedBox(height: 2),
                                            Text('Email: ${customer.email}', style: TextStyle(color: AppColors.text.withOpacity(0.8), fontSize: 14)),
                                            Text('Phone: ${customer.phone}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
                                            if (customer.companyName != null)
                                              Text('Company: ${customer.companyName}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
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
                                          final uri = Uri(scheme: 'tel', path: customer.phone);
                                          launchUrl(uri);
                                        },
                                        tooltip: 'Call',
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.message, color: AppColors.icon, size: 28),
                                        onPressed: () {
                                          String cleanPhone = customer.phone.replaceAll(RegExp(r'[^\d+]'), '');
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
                                          final uri = Uri(scheme: 'mailto', path: customer.email);
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