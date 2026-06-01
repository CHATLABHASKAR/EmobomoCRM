import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/themes/app_colors.dart';
import '../../customers/customer_form_screen.dart';
import '../../leads/lead_form_screen.dart';
import '../../onboarding/onboard_employee_screen.dart';
import '../../tasks/task_form_screen.dart';

class CrmQuickActionsWidget extends StatelessWidget {
  final int leadCount;
  final int customerCount;
  final int employeeCount;
  final int taskCount;

  const CrmQuickActionsWidget({
    Key? key,
    required this.leadCount,
    required this.customerCount,
    required this.employeeCount,
    required this.taskCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final actions = [
      _QuickAction(
        icon: Icons.person_add,
        color: Colors.blue,
        title: 'Leads',
        subtitle: 'Create new lead',
        count: leadCount,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(top: 40, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: LeadFormScreen(),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.group_add,
        color: Colors.green,
        title: 'Customers',
        subtitle: 'Create new customer',
        count: customerCount,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(top: 40, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: CustomerFormScreen(),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.person,
        color: Colors.orange,
        title: 'Employees',
        subtitle: 'Onboard employee',
        count: employeeCount,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(top: 40, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: OnboardEmployeeScreen(),
          ),
        ),
      ),
      _QuickAction(
        icon: Icons.playlist_add_check,
        color: Colors.purple,
        title: 'Create Task',
        subtitle: 'Assign a task',
        count: taskCount,
        onTap: () => showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (ctx) => Padding(
            padding: EdgeInsets.only(top: 40, bottom: MediaQuery.of(ctx).viewInsets.bottom),
            child: TaskFormScreen(),
          ),
        ),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.0,
        children: actions.map((action) => _QuickActionCard(action: action)).toList(),
      ),
    );
  }
}

class _QuickAction {
  final IconData icon;
  final Color color;
  final String title;
  final String subtitle;
  final int count;
  final VoidCallback onTap;
  _QuickAction({
    required this.icon,
    required this.color,
    required this.title,
    required this.subtitle,
    required this.count,
    required this.onTap,
  });
}

class _QuickActionCard extends StatelessWidget {
  final _QuickAction action;
  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: action.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: action.color.withOpacity(0.18), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: action.color.withOpacity(0.07),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: action.color.withOpacity(0.12),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(action.icon, color: action.color, size: 24),
            ),
            SizedBox(height: 8),
            Text(
              '${action.count}',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: action.color),
            ),
            SizedBox(height: 4),
            Text(
              action.title,
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              action.subtitle,
              style: TextStyle(fontSize: 13, color: Colors.black54),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
} 