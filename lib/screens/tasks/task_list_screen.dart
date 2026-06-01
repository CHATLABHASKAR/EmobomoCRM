import 'package:flutter/material.dart';
import 'package:crm/screens/dashboard/widgets/crm_scaffold.dart';
import 'package:get/get.dart';
import '../../app/controllers/task_controller.dart';
import 'task_form_screen.dart';

class TaskListScreen extends StatelessWidget {
  final controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    controller.fetchTasks();

    return CrmScaffold(
      currentIndex: 4, // Tasks tab index (adjust as needed)
      role: 'admin',   // Or get from user/session
      child: Obx(() {
        if (controller.tasks.isEmpty) {
          return Center(child: Text("No tasks available."));
        }

        return ListView.builder(
          itemCount: controller.tasks.length,
          itemBuilder: (context, index) {
            final task = controller.tasks[index];
            return ListTile(
              title: Text(task.title),
              subtitle: Text("Due: ${task.dueDate.toLocal()}"),
              trailing: task.status == 'done'
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () => controller.markAsDone(task),
                    ),
              onTap: () => Get.to(() => TaskFormScreen(existingTask: task)),
            );
          },
        );
      }),
      // You can add a floatingActionButton here if needed
    );
  }
}
