import 'package:get/get.dart';
import '../models/task_model.dart';
import '../services/api_service.dart';
import '../services/notification_service.dart';

class TaskController extends GetxController {
  var tasks = <TaskModel>[].obs;

  void fetchTasks() async {
    tasks.value = await ApiService.fetchTasks(); // API call
  }

  void fetchTasksByLead(String leadId) async {
    tasks.value = await ApiService.fetchTasks(leadId: leadId);
  }

  void addTask(TaskModel task) async {
    await ApiService.addTask(task);
    await NotificationService.scheduleTaskReminder(
      id: int.parse(task.id),
      title: task.title,
      dateTime: task.dueDate,
    );
    fetchTasks();
  }

  void updateTask(TaskModel task) async {
    await ApiService.updateTask(task);
    await NotificationService.scheduleTaskReminder(
      id: int.parse(task.id),
      title: task.title,
      dateTime: task.dueDate,
    );
    fetchTasks();
  }

  void markAsDone(TaskModel task) async {
    task = TaskModel(
      id: task.id,
      title: task.title,
      dueDate: task.dueDate,
      leadId: task.leadId,
      status: 'done',
      notes: task.notes,
    );
    await ApiService.updateTask(task);
    fetchTasks();
  }

  void deleteTask(TaskModel task) async {
    await ApiService.deleteTask(task.id);
    await NotificationService.cancelNotification(int.parse(task.id));
    fetchTasks();
  }
}
