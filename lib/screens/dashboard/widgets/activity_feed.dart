import 'package:flutter/material.dart';

class ActivityFeed extends StatelessWidget {
  final List<dynamic> activities;

  const ActivityFeed({required this.activities});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Activity", style: Theme.of(context).textTheme.titleMedium),
        SizedBox(height: 10),
        ...activities.map((a) => ListTile(title: Text(a.toString()))),
      ],
    );
  }
}
