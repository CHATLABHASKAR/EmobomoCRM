import 'package:flutter/material.dart';
import 'crm_dashboard_header.dart';
import 'package:crm/app/widgets/app_bottom_nav_bar.dart';
import 'package:get_storage/get_storage.dart';

class CrmScaffold extends StatelessWidget {
  final Widget child;
  final int currentIndex;
  final String role;
  final void Function(int)? onTab;

  const CrmScaffold({
    Key? key,
    required this.child,
    required this.currentIndex,
    required this.role,
    this.onTab,
  }) : super(key: key);

  static String getUserRole() {
    final box = GetStorage();
    final userData = box.read('user');
    if (userData != null && userData is Map) {
      final role = userData['role'] ?? userData['user']?['role'];
      return (role ?? '').toString().toLowerCase();
    }
    return 'admin';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Column(
        children: [
          const CrmDashboardHeader(),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: AppBottomNavBar(
        role: role,
        currentIndex: currentIndex,
        onTap: onTab ?? (index) {},
      ),
    );
  }
} 