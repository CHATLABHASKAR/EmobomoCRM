import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/themes/app_colors.dart';
import '../../customers/customer_detail_screen.dart';
import '../../customers/customer_list_screen.dart';
import '../../../app/models/customer_model.dart';

class RecentCustomersCard extends StatelessWidget {
  final List<CustomerModel> customers;
  const RecentCustomersCard({Key? key, required this.customers}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                'Recent Customers',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.text),
              ),
              Icon(Icons.group, color: AppColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          ...customers.take(3).map((customer) => _buildCustomerItem(context, customer)).toList(),
          if (customers.length > 3) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.to(() => CustomerListScreen()),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'View All Customers',
                      style: TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w500,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(Icons.arrow_forward_ios, color: AppColors.primary, size: 14),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCustomerItem(BuildContext context, CustomerModel customer) {
    return GestureDetector(
      onTap: () => Get.to(() => CustomerDetailScreen(customer: customer)),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            Icon(Icons.person, color: AppColors.primary, size: 28),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    customer.contactName,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    customer.email,
                    style: TextStyle(fontSize: 13, color: AppColors.text.withOpacity(0.7)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    customer.phone,
                    style: TextStyle(fontSize: 13, color: AppColors.text.withOpacity(0.7)),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 