import 'package:flutter/material.dart';
import '../../../app/themes/app_colors.dart';
import '../../../app/models/employee_model.dart';

class EmployeesByRoleCard extends StatelessWidget {
  final List<EmployeeModel> employees;
  const EmployeesByRoleCard({Key? key, required this.employees}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalEmployees = employees.length;
    final Map<String, int> roleCounts = {};
    for (final emp in employees) {
      final role = (emp.roleName ?? 'Unknown').trim();
      roleCounts[role] = (roleCounts[role] ?? 0) + 1;
    }
    final roles = roleCounts.keys.toList();

    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Employees by Role',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.text),
              ),
              Icon(Icons.badge, color: AppColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  title: 'Total',
                  value: totalEmployees.toString(),
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ...roles.map((role) => _buildRoleItem(role, roleCounts[role] ?? 0)).toList(),
        ],
      ),
    );
  }

  Widget _buildBalanceItem({
    required String title,
    required String value,
    required Color color,
  }) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: color),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(fontSize: 13, color: AppColors.text.withOpacity(0.7)),
        ),
      ],
    );
  }

  Widget _buildRoleItem(String role, int count) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              role,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: AppColors.text),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(
            '$count',
            style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.primary),
          ),
        ],
      ),
    );
  }
} 