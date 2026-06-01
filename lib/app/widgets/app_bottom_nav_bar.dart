import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../themes/app_colors.dart';
import 'package:get_storage/get_storage.dart';

class AppBottomNavBar extends StatelessWidget {
  final String role;
  final int currentIndex;
  final ValueChanged<int> onTap;

  AppBottomNavBar({
    required this.role,
    required this.currentIndex,
    required this.onTap,
  });

  List<BottomNavigationBarItem> _buildItems() {
    if (role == 'admin') {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Employees'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ];
    } else if (role == 'sales_exec') {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ];
    } else if (role == 'telesales') {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ];
    } else {
      return [
        BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
        BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Leads'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Customers'),
        BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
      ];
    }
  }

  List<String> _routesForRole() {
    if (role == 'admin') {
      return [
        '/dashboard/admin',
        '/leads',
        '/customers',
        '/employees',
        '/settings',
      ];
    } else if (role == 'sales_exec') {
      return [
        '/dashboard/sales_exec',
        '/leads',
        '/customers',
        '/settings',
      ];
    } else if (role == 'telesales') {
      return [
        '/dashboard/telesales',
        '/leads',
        '/customers',
        '/settings',
      ];
    } else {
      // Fallback: check if backend role is insidesales
      final box = GetStorage();
      final userData = box.read('user');
      String backendRole = '';
      if (userData != null && userData is Map) {
        final userMap = userData['user'] is Map ? userData['user'] as Map : null;
        backendRole = (userData['role'] as String?) ?? (userMap != null ? userMap['role'] as String? : null) ?? '';
      }
      backendRole = backendRole.toLowerCase();
      if (backendRole == 'insidesales') {
        return [
          '/dashboard/telesales',
          '/leads',
          '/customers',
          '/settings',
        ];
      }
      // Default fallback
      return [
        '/dashboard',
        '/leads',
        '/customers',
        '/settings',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _buildItems();
    final routes = _routesForRole();
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          color: AppColors.card.withOpacity(0.85),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: currentIndex,
            onTap: (index) {
              if (index != currentIndex) {
                onTap(index);
                if (index < routes.length) {
                  final route = routes[index];
                  // Check if the route is registered
                  final match = Get.routeTree.matchRoute(route);
                  if (match.route != null) {
                    Get.offAllNamed(route);
                  } else {
                    print('Route $route is not registered!');
                    // Optionally, show a snackbar or navigate to a default dashboard
                    // Get.snackbar('Error', 'Dashboard not available for your role');
                  }
                }
              }
            },
            items: items,
            selectedItemColor: Theme.of(context).colorScheme.primary,
            unselectedItemColor: Colors.grey,
            showUnselectedLabels: true,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
      ),
    );
  }
} 