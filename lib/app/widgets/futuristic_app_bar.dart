// lib/app/widgets/futuristic_app_bar.dart
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'user_avatar.dart';
import '../themes/app_colors.dart';
import 'package:get/get.dart';

class FuturisticAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final List<Widget>? actions;
  final bool showBack;

  const FuturisticAppBar({
    Key? key,
    this.title,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.actions,
    this.showBack = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _box = GetStorage();
    final userData = _box.read('user');
    String name = '';
    String? imageUrl;
    String role = '';
    if (userData != null && userData is Map) {
      final userMap = userData['user'] is Map ? userData['user'] as Map : null;
      name = (userData['name'] as String?) ?? (userMap != null ? userMap['name'] as String? : null) ?? '';
      imageUrl = (userData['profileImage'] as String?) ?? (userMap != null ? userMap['profileImage'] as String? : null);
      role = (userData['role'] as String?) ?? (userMap != null ? userMap['role'] as String? : null) ?? '';
    }
    return AppBar(
      backgroundColor: AppColors.background,
      elevation: 0,
      leading: showBack
          ? IconButton(
              icon: Icon(Icons.arrow_back, color: AppColors.icon),
              onPressed: () {
                if (Navigator.of(context).canPop()) {
                  Navigator.of(context).pop();
                } else {
                  // Get the role from storage, fallback to empty string
                  final _box = GetStorage();
                  String role = '';
                  final userData = _box.read('user');
                  if (userData != null && userData is Map) {
                    final userMap = userData['user'] is Map ? userData['user'] as Map : null;
                    role = (userData['role'] as String?) ?? (userMap != null ? userMap['role'] as String? : null) ?? '';
                  }
                  final safeRole = (role).toLowerCase();
                  if (safeRole == 'admin') {
                    Get.offAllNamed('/dashboard/admin');
                  } else if (safeRole == 'sales_exec') {
                    Get.offAllNamed('/dashboard/sales_exec');
                  } else if (safeRole == 'telesales') {
                    Get.offAllNamed('/dashboard/telesales');
                  } else {
                    Get.offAllNamed('/dashboard');
                  }
                }
              },
            )
          : null,
      title: Row(
        children: [
          UserAvatar(imageUrl: imageUrl, radius: 20),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Hi, $name', style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 16)),
              if (role.isNotEmpty)
                Text(role, style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 12)),
            ],
          ),
          if (title != null) ...[
            SizedBox(width: 16),
            Text(title!, style: TextStyle(color: AppColors.text, fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ],
      ),
      actions: [
        Stack(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: AppColors.icon),
              onPressed: onNotificationTap,
            ),
            if (notificationCount > 0)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Text('$notificationCount', style: TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
          ],
        ),
        if (actions != null) ...actions!,
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
} 