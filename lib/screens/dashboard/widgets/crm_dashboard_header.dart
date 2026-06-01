import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../app/themes/app_colors.dart';

class CrmDashboardHeader extends StatelessWidget {
  final bool showNotification;
  final VoidCallback? onNotificationTap;
  final bool showBack;

  const CrmDashboardHeader({
    Key? key,
    this.showNotification = true,
    this.onNotificationTap,
    this.showBack = false,
  }) : super(key: key);

  String get userName {
    final _box = GetStorage();
    final userData = _box.read('user');
    if (userData != null && userData is Map) {
      final userMap = userData['user'] is Map ? userData['user'] as Map : null;
      return (userData['name'] as String?) ?? (userMap != null ? userMap['name'] as String? : null) ?? 'User';
    }
    return 'User';
  }

  String get userRole {
    final _box = GetStorage();
    final userData = _box.read('user');
    if (userData != null && userData is Map) {
      final userMap = userData['user'] is Map ? userData['user'] as Map : null;
      return (userData['role'] as String?) ?? (userMap != null ? userMap['role'] as String? : null) ?? '';
    }
    return '';
  }

  String get currentDate => DateFormat('EEEE, MMMM d, yyyy').format(DateTime.now());

  bool get isConnected => true; // Replace with real connectivity logic if needed

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(24, 24, 24, 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.05),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'CRM',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 16),
                    Text(
                      'CRM System',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        fontSize: 22,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: isConnected ? AppColors.successBackground : AppColors.errorBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: isConnected ? AppColors.success : AppColors.error,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            isConnected ? 'Online' : 'Offline',
                            style: TextStyle(
                              color: isConnected ? AppColors.success : AppColors.error,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (showNotification) ...[
                      SizedBox(width: 16),
                      IconButton(
                        icon: Icon(Icons.notifications_outlined, color: AppColors.icon, size: 28),
                        onPressed: onNotificationTap ?? () => Get.toNamed('/notification'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back,',
                  style: TextStyle(
                    color: AppColors.subtext,
                    fontSize: 15,
                  ),
                ),
                Text(
                  userName,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 20,
                    color: AppColors.text,
                  ),
                ),
                if (userRole.isNotEmpty)
                  Text(
                    userRole,
                    style: TextStyle(
                      color: AppColors.subtext,
                      fontSize: 14,
                    ),
                  ),
                SizedBox(height: 4),
                Text(
                  currentDate,
                  style: TextStyle(
                    color: AppColors.subtext,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 