import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import 'package:get/get.dart';
import 'lead_form_screen.dart';
import 'lead_detail_screen.dart';
import '../../app/controllers/lead_controller.dart';
import '../../app/widgets/neon_glass_container.dart';
import 'package:flutter/widgets.dart';
import '../../app/widgets/user_avatar.dart';
import '../../app/themes/app_colors.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LeadListScreen extends StatefulWidget {
  @override
  State<LeadListScreen> createState() => _LeadListScreenState();
}

class _LeadListScreenState extends State<LeadListScreen> {
  final controller = Get.put(LeadController());
  String filterQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    controller.fetchLeads();
  }

  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 1, // Leads tab index
      role: CrmScaffold.getUserRole(),
      child: Obx(() {
        final leads = controller.leads;
        final filteredLeads = leads.where((lead) {
          final query = filterQuery.toLowerCase();
          return lead.name.toLowerCase().contains(query) ||
                 (lead.email?.toLowerCase().contains(query) ?? false) ||
                 (lead.status?.toLowerCase().contains(query) ?? false);
        }).toList();
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Leads',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.text),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 8,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  icon: Icon(Icons.add),
                  label: Text('Add Lead'),
                  onPressed: () async {
                    final result = await showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: LeadFormScreen(),
                      ),
                    );
                    if (result != null) {
                      controller.fetchLeads();
                    }
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search by name, email, or status',
                  prefixIcon: Icon(Icons.search, color: AppColors.icon),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                  filled: true,
                  fillColor: AppColors.glass,
                ),
                onChanged: (value) {
                  setState(() {
                    filterQuery = value;
                  });
                },
              ),
            ),
            Expanded(
              child: filteredLeads.isEmpty
                  ? Center(child: Text('No leads found.', style: TextStyle(color: AppColors.text)))
                  : ListView.builder(
                      shrinkWrap: true,
                      itemCount: filteredLeads.length,
                      itemBuilder: (context, index) {
                        final lead = filteredLeads[index];
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 0.0),
                          child: GestureDetector(
                            onTap: () {
                              Get.to(() => LeadDetailScreen(lead: lead));
                            },
                            child: NeonGlassContainer(
                              width: MediaQuery.of(context).size.width * 0.9,
                              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                              borderRadius: BorderRadius.circular(20),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  UserAvatar(imageUrl: null, radius: 28),
                                  SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(lead.name, style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.text, fontSize: 18)),
                                        SizedBox(height: 2),
                                        Text('Email: ${lead.email}', style: TextStyle(color: AppColors.text.withOpacity(0.8), fontSize: 14)),
                                        Text('Status: ${lead.status}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
                                        if (lead.source != null)
                                          Text('Source: ${lead.source}', style: TextStyle(color: AppColors.text.withOpacity(0.7), fontSize: 13)),
                                      ],
                                    ),
                                  ),
                                  Icon(Icons.chevron_right, color: AppColors.icon, size: 28),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        );
      }),
    );
  }
}
