import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final _box = GetStorage();
    String role = '';
    final userData = _box.read('user');
    if (userData != null && userData is Map) {
      final userMap = userData['user'] is Map ? userData['user'] as Map : null;
      role = (userData['role'] as String?) ?? (userMap != null ? userMap['role'] as String? : null) ?? '';
    }
    role = role.toLowerCase();
    final int currentIndex = (role == 'admin') ? 4 : 3; // Settings is last tab for all roles
    return CrmScaffold(
      currentIndex: currentIndex,
      role: role,
      child: Center(child: Text('Settings Screen')),
    );
  }
} 