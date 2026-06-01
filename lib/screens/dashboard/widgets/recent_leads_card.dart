// ignore_for_file: unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../app/themes/app_colors.dart';
import '../../leads/lead_detail_screen.dart';
import '../../leads/lead_list_screen.dart';
import '../../../app/models/leads_model.dart';

class RecentLeadsCard extends StatelessWidget {
  final List<LeadModel> leads;
  const RecentLeadsCard({Key? key, required this.leads}) : super(key: key);

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
                'Recent Leads',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18, color: AppColors.text),
              ),
              Icon(Icons.people, color: AppColors.primary, size: 22),
            ],
          ),
          const SizedBox(height: 12),
          ...leads.take(3).map((lead) => _buildLeadItem(context, lead)).toList(),
          if (leads.length > 3) ...[
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => Get.to(() => LeadListScreen()),
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
                      'View All Leads',
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

  Widget _buildLeadItem(BuildContext context, LeadModel lead) {
    return GestureDetector(
      onTap: () => Get.to(() => LeadDetailScreen(lead: lead)),
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
                    lead.name,
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15, color: AppColors.text),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (lead.email != null && lead.email.isNotEmpty)
                    Text(
                      lead.email,
                      style: TextStyle(fontSize: 13, color: AppColors.text.withOpacity(0.7)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  if (lead.phone != null && lead.phone.isNotEmpty)
                    Text(
                      lead.phone,
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