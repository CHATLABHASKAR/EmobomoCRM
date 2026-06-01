import 'package:crm/app/controllers/task_controller.dart';
import 'package:crm/app/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';


class CalendarScreen extends StatelessWidget {
  final controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    controller.fetchTasks();

    return Scaffold(
      appBar: AppBar(title: Text("Task Calendar")),
      body: Obx(() {
        return SfCalendar(
          view: CalendarView.month,
          dataSource: TaskCalendarSource(controller.tasks),
          monthViewSettings: MonthViewSettings(
            appointmentDisplayMode: MonthAppointmentDisplayMode.appointment,
          ),
        );
      }),
    );
  }
}

class TaskCalendarSource extends CalendarDataSource {
  TaskCalendarSource(List<TaskModel> tasks) {
    appointments = tasks;
  }

  @override
  DateTime getStartTime(int index) => appointments![index].dueDate;
  @override
  DateTime getEndTime(int index) => appointments![index].dueDate.add(Duration(hours: 1));
  @override
  String getSubject(int index) => appointments![index].title;
  @override
  Color getColor(int index) => appointments![index].status == 'done' ? Colors.green : Colors.red;
}
