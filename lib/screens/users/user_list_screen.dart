import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';

class UserListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 6, // Users tab index (adjust as needed)
      role: 'admin',   // Or get from user/session
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 350,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.2),
            ),
            alignment: Alignment.center,
            child: Text('User List Screen', style: TextStyle(fontSize: 22, color: Colors.black87, fontWeight: FontWeight.w600)),
          ),
        ),
      ),
    );
  }
} 