import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm/app/controllers/dashboard_controller.dart';
import 'widgets/kpi_card.dart';
import 'widgets/shortcuts_panel.dart';
import 'widgets/activity_feed.dart';
import 'package:crm/app/widgets/app_bottom_nav_bar.dart';
import '../../app/widgets/neon_glass_container.dart';
import '../../app/themes/app_colors.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'widgets/crm_dashboard_header.dart';
import 'widgets/crm_scaffold.dart';
import 'widgets/quick_actions_widget.dart';
import 'package:crm/app/controllers/lead_controller.dart';
import 'package:crm/app/controllers/customer_controller.dart';
import 'package:crm/app/controllers/employee_list_controller.dart';
import 'package:crm/app/controllers/task_controller.dart';
import 'widgets/recent_customers_card.dart';
import 'widgets/recent_leads_card.dart';
import 'widgets/employees_by_role_card.dart';

class TelesalesDashboard extends StatefulWidget {
  @override
  _TelesalesDashboardState createState() => _TelesalesDashboardState();
}

class _TelesalesDashboardState extends State<TelesalesDashboard> {
  final DashboardController controller = Get.put(DashboardController());
  final LeadController leadController = Get.put(LeadController());
  final CustomerController customerController = Get.put(CustomerController());
  final EmployeeListController employeeController = Get.put(EmployeeListController());
  final TaskController taskController = Get.put(TaskController());
  int _selectedIndex = 0; // Dashboard tab index for telesales

  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 0, // Dashboard tab index for telesales
      role: 'telesales',
      child: Obx(() => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Only leads and customers quick actions
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: CrmQuickActionsWidget(
                      leadCount: leadController.leads.length,
                      customerCount: customerController.customers.length,
                      employeeCount: 0,
                      taskCount: 0,
                    ),
                  ),
                ],
              ),
              RecentCustomersCard(customers: customerController.customers),
              RecentLeadsCard(leads: leadController.leads),
              // EmployeesByRoleCard and task widgets removed for telesales
            ],
          ),
        ),
      )),
    );
  }
}
