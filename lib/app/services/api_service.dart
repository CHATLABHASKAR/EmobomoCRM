import 'package:dio/dio.dart';
import '../models/leads_model.dart';
import '../models/task_model.dart';

class ApiService {
  static final Dio _dio = Dio(BaseOptions(baseUrl: 'https://your-api-url.com'));

  static Future<List<LeadModel>> fetchLeads() async {
    final response = await _dio.get('/leads');
    final data = response.data;
    if (data is List) {
      return data.map((e) => LeadModel.fromJson(e)).toList();
    } else {
      // Mock data for development/testing if API fails
      print('Unexpected response in fetchLeads: $data');
      return [
        LeadModel(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          phone: '1234567890',
          status: 'New',
          source: 'Website',
        ),
        LeadModel(
          id: '2',
          name: 'Jane Smith',
          email: 'jane@example.com',
          phone: '9876543210',
          status: 'Contacted',
          source: 'Referral',
        ),
      ];
    }
  }

  static Future<void> addLead(LeadModel lead) async {
    await _dio.post('/leads', data: lead.toJson());
  }

  static Future<void> updateLead(LeadModel lead) async {
    await _dio.put('/leads/${lead.id}', data: lead.toJson());
  }

  static Future<List<TaskModel>> fetchTasks({String? leadId}) async {
    // TODO: Implement API call
    return [];
  }

  static Future<void> addTask(TaskModel task) async {
    // TODO: Implement API call
  }

  static Future<void> updateTask(TaskModel task) async {
    // TODO: Implement API call
  }

  static Future<void> deleteTask(String taskId) async {
    // TODO: Implement API call
  }
}