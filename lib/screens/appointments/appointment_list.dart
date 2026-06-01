import 'package:flutter/material.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'package:get/get.dart';

class AppointmentList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FuturisticAppBar(
        title: 'Appointment List',
        notificationCount: 0,
        onNotificationTap: () => Get.toNamed('/notification'),
      ),
      body: Center(child: Text('Appointment List')),
    );
  }
} 