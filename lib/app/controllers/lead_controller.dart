import 'package:crm/app/services/api_service.dart';
import 'package:get/get.dart';
import '../models/leads_model.dart';

class LeadController extends GetxController {
  var leads = <LeadModel>[].obs;

  void fetchLeads() async {
    leads.value = await ApiService.fetchLeads();
  }

  void addLead(LeadModel lead) async {
    await ApiService.addLead(lead);
    fetchLeads();
  }

  void updateLead(LeadModel lead) async {
    await ApiService.updateLead(lead);
    fetchLeads();
  }
}