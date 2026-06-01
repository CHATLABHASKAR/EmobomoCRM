
import 'package:crm/app/controllers/kanban_controller.dart';
import 'package:crm/app/models/lead_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';


class KanbanDashboard extends StatelessWidget {
  final KanbanController controller = Get.put(KanbanController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Kanban View")),
      body: Obx(() => DragAndDropLists(
        children: controller.stages.map((stage) {
          final leads = controller.board[stage] ?? [];
          return DragAndDropList(
            header: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(stage, style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            children: leads.map((lead) => DragAndDropItem(
              child: LeadCard(lead: lead),
            )).toList(),
          );
        }).toList(),
        onItemReorder: (oldItemIndex, oldListIndex, newItemIndex, newListIndex) {
          controller.moveLead(oldListIndex, oldItemIndex, newListIndex, newItemIndex);
        },
        onListReorder: (oldListIndex, newListIndex) {},
        listPadding: EdgeInsets.all(12),
        listDecoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        listWidth: 260,
        axis: Axis.horizontal,
      )),
    );
  }
}

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  const LeadCard({required this.lead});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.all(6),
      child: ListTile(
        title: Text(lead.name),
        subtitle: Text("ID: ${lead.id}"),
      ),
    );
  }
}
