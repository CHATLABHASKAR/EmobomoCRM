import 'package:flutter/material.dart';

class ShortcutsPanel extends StatelessWidget {
  final String role;

  const ShortcutsPanel({required this.role});

  @override
  Widget build(BuildContext context) {
    List<Widget> items = [];

    if (role == 'admin') {
      items = [
        _shortcut(Icons.people, "Users"),
        _shortcut(Icons.analytics, "Reports"),
      ];
    } else if (role == 'sales_exec') {
      items = [
        _shortcut(Icons.assignment, "My Leads"),
        _shortcut(Icons.calendar_today, "Calendar"),
      ];
    } else if (role == 'telesales') {
      items = [
        _shortcut(Icons.call, "Calls"),
        _shortcut(Icons.check_circle, "Follow-ups"),
      ];
    }

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: items);
  }

  Widget _shortcut(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(child: Icon(icon)),
        SizedBox(height: 8),
        Text(label),
      ],
    );
  }
}
