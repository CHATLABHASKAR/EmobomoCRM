import 'package:get/get.dart';
import '../models/lead_model.dart';

class KanbanController extends GetxController {
  var stages = ['New', 'Contacted', 'Demo', 'Won', 'Lost'];
  var board = <String, List<LeadModel>>{}.obs;

  @override
  void onInit() {
    loadLeads();
    super.onInit();
  }

  void loadLeads() {
    board.value = {
      'New': [
        LeadModel(id: '1', name: 'John Doe', stage: 'New'),
        LeadModel(id: '2', name: 'Acme Inc.', stage: 'New'),
      ],
      'Contacted': [],
      'Demo': [],
      'Won': [],
      'Lost': [],
    };
  }

  void moveLead(int oldListIndex, int oldItemIndex, int newListIndex, int newItemIndex) {
    String oldStage = stages[oldListIndex];
    String newStage = stages[newListIndex];

    final lead = board[oldStage]!.removeAt(oldItemIndex);
    lead.stage = newStage; // Optional: update model
    board[newStage]!.insert(newItemIndex, lead);

    board.refresh();

    // Optional: Update backend (e.g. via AWS API)
    // ApiService.updateLeadStage(lead.id, newStage);
  }
}
