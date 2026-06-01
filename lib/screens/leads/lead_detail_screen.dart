import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import '../../app/models/leads_model.dart';
import '../../app/controllers/task_controller.dart';
import 'package:get/get.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'lead_form_screen.dart';
import '../tasks/task_form_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class LeadDetailScreen extends StatelessWidget {
  final LeadModel lead;
  LeadDetailScreen({required this.lead});

  final taskController = Get.put(TaskController());

  Future<void> _launchCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch phone app');
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleanPhone.startsWith('+') && cleanPhone.length == 10) {
      cleanPhone = '+91$cleanPhone';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp');
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<TaskController>();
    taskController.fetchTasksByLead(lead.id);

    return CrmScaffold(
      currentIndex: 1, // Leads tab index
      role: CrmScaffold.getUserRole(),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    detailRow("Name", lead.name),
                    detailRow("Email", lead.email),
                    detailRow("Phone", lead.phone),
                    detailRow("Status", lead.status),
                    detailRow("Source", lead.source),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          icon: Icon(Icons.phone),
                          label: Text("Call"),
                          onPressed: () => _launchCall(lead.phone),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                          label: Text("WhatsApp"),
                          onPressed: () => _launchWhatsApp(lead.phone),
                        ),
                        SizedBox(width: 10),
                        ElevatedButton.icon(
                          icon: Icon(Icons.email),
                          label: Text("Email"),
                          onPressed: () => _launchEmail(lead.email),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            Text("📝 Tasks for this Lead", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Obx(() {
              final tasks = taskController.tasks.where((t) => t.leadId == lead.id).toList();

              if (tasks.isEmpty) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text("No tasks assigned."),
                );
              }

              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: tasks.length,
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return ListTile(
                    title: Text(task.title),
                    subtitle: Text("Due: ${task.dueDate.toLocal().toString().split(' ')[0]}"),
                    trailing: task.status == 'done'
                        ? Icon(Icons.check_circle, color: Colors.green)
                        : IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () => taskController.markAsDone(task),
                          ),
                    onTap: () => Get.to(() => TaskFormScreen(existingTask: task)),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget detailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text("$title:", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(width: 10),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
