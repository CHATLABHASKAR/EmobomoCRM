class TaskModel {
  final String id;
  final String title;
  final DateTime dueDate;
  final String leadId;
  final String status; // pending, done
  final String notes;

  TaskModel({
    required this.id,
    required this.title,
    required this.dueDate,
    required this.leadId,
    required this.status,
    required this.notes,
  });

  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'],
      title: json['title'],
      dueDate: DateTime.parse(json['dueDate']),
      leadId: json['leadId'],
      status: json['status'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'dueDate': dueDate.toIso8601String(),
    'leadId': leadId,
    'status': status,
    'notes': notes,
  };
}
