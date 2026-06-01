import 'package:crm/app/controllers/dashboard_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/kpi_card.dart';
import 'widgets/shortcuts_panel.dart';
import 'widgets/activity_feed.dart';
import 'package:crm/app/widgets/app_bottom_nav_bar.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'widgets/crm_dashboard_header.dart';

class SalesDashboard extends StatefulWidget {
  @override
  _SalesDashboardState createState() => _SalesDashboardState();
}

class _SalesDashboardState extends State<SalesDashboard> {
  final DashboardController controller = Get.put(DashboardController());
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      backgroundColor: Colors.white,
      body: Obx(() => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CrmDashboardHeader(),
              Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                KpiCard(title: "My Leads", value: "${controller.kpiData['leadsToday']}"),
                const SizedBox(width: 10),
                KpiCard(title: "Conversion", value: "${controller.kpiData['conversionRate']}"),
              ],
            ),
            const SizedBox(height: 20),
            const ShortcutsPanel(role: 'sales_exec'),
            const SizedBox(height: 20),
            ActivityFeed(activities: controller.recentActivity),
          ],
                ),
              ),
            ],
          ),
        ),
      )),
      bottomNavigationBar: AppBottomNavBar(
        role: 'sales_exec',
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
