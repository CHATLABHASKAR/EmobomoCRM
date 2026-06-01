import 'package:crm/app/controllers/task_controller.dart';
import 'package:crm/app/models/task_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/themes/app_colors.dart';


class TaskFormScreen extends StatefulWidget {
  final TaskModel? existingTask;
  final String? leadId;

  const TaskFormScreen({this.existingTask, this.leadId});

  @override
  _TaskFormScreenState createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final controller = Get.find<TaskController>();

  late TextEditingController titleController;
  late TextEditingController noteController;
  DateTime selectedDate = DateTime.now();
  String status = "pending";

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.existingTask?.title ?? '');
    noteController = TextEditingController(text: widget.existingTask?.notes ?? '');
    selectedDate = widget.existingTask?.dueDate ?? DateTime.now();
    status = widget.existingTask?.status ?? "pending";
  }

  Widget _futuristicField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      maxLines: maxLines,
      style: TextStyle(fontSize: 15, color: AppColors.text, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        filled: true,
        fillColor: AppColors.glass,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary.withOpacity(0.18), width: 1.2),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        labelStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
        hintStyle: TextStyle(color: AppColors.text.withOpacity(0.5)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: AppColors.card,
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 18.0),
                  child: Text(
                    widget.existingTask == null ? 'Add Task' : 'Edit Task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ),
                _futuristicField(
                  titleController,
                  "Task Title",
                  "Enter task title",
                  validator: (value) => value!.isEmpty ? "Title required" : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  noteController,
                  "Notes",
                  "Enter task notes",
                  maxLines: 3,
                ),
                const SizedBox(height: 14),
                // Styled date picker field
                _styledDatePickerField(
                  context: context,
                  selectedDate: selectedDate,
                  onDatePicked: (date) => setState(() => selectedDate = date),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 8,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      final task = TaskModel(
                        id: widget.existingTask?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                        title: titleController.text,
                        dueDate: selectedDate,
                        leadId: widget.leadId ?? widget.existingTask?.leadId ?? '',
                        status: status,
                        notes: noteController.text,
                      );

                      if (widget.existingTask != null) {
                        controller.updateTask(task);
                      } else {
                        controller.addTask(task);
                      }

                      Get.back();
                    }
                  },
                  child: Text(widget.existingTask == null ? 'Add Task' : 'Update Task'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget _styledDatePickerField({required BuildContext context, required DateTime selectedDate, required void Function(DateTime) onDatePicked}) {
  return GestureDetector(
    onTap: () async {
      final picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime.now().subtract(Duration(days: 1)),
        lastDate: DateTime(2100),
      );
      if (picked != null) onDatePicked(picked);
    },
    child: AbsorbPointer(
      child: TextFormField(
        readOnly: true,
        controller: TextEditingController(text: selectedDate.toLocal().toString().split(" ")[0]),
        decoration: InputDecoration(
          labelText: 'Due Date',
          floatingLabelBehavior: FloatingLabelBehavior.auto,
          filled: true,
          fillColor: AppColors.glass,
          contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.3), width: 1.2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary.withOpacity(0.18), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(color: AppColors.primary, width: 2),
          ),
          labelStyle: TextStyle(color: AppColors.primary, fontWeight: FontWeight.w600),
          hintStyle: TextStyle(color: AppColors.text.withOpacity(0.5)),
        ),
      ),
    ),
  );
}
