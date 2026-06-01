import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../app/models/customer_model.dart';
import '../../app/widgets/user_avatar.dart';
import '../../app/themes/app_colors.dart';
import '../dashboard/widgets/crm_scaffold.dart';

class CustomerDetailScreen extends StatelessWidget {
  final CustomerModel customer;
  CustomerDetailScreen({required this.customer});

  void _call(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not launch phone app');
    }
  }

  void _whatsapp(String phone) async {
    String cleanPhone = phone.replaceAll(RegExp(r'[^\d+]'), '');
    if (!cleanPhone.startsWith('+') && cleanPhone.length == 10) {
      cleanPhone = '+91$cleanPhone';
    }
    final uri = Uri.parse('https://wa.me/$cleanPhone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      Get.snackbar('Error', 'Could not open WhatsApp');
    }
  }

  void _gmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar('Error', 'Could not open email app');
    }
  }

  @override
  Widget build(BuildContext context) {
    return CrmScaffold(
      currentIndex: 2, // Customers tab index
      role: CrmScaffold.getUserRole(),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: UserAvatar(imageUrl: customer.profileImage, radius: 40)),
            SizedBox(height: 16),
            Text(customer.contactName, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Email: ${customer.email}'),
            Text('Phone: ${customer.phone}'),
            if (customer.alternativePhone != null && customer.alternativePhone!.isNotEmpty)
              Text('Alternative Phone: ${customer.alternativePhone!}'),
            if (customer.companyName != null && customer.companyName!.isNotEmpty)
              Text('Company: ${customer.companyName!}'),
            if (customer.salesContact.isNotEmpty)
              Text('Sales Contact: ${customer.salesContact}'),
            if (customer.source.isNotEmpty)
              Text('Source: ${customer.source}'),
            if (customer.followUpDate != null && customer.followUpDate!.isNotEmpty)
              Text('Follow Up Date: ${customer.followUpDate!}'),
            if (customer.demo.isNotEmpty)
              Text('Demo: ${customer.demo}'),
            if (customer.city.isNotEmpty)
              Text('City: ${customer.city}'),
            if (customer.state.isNotEmpty)
              Text('State: ${customer.state}'),
            if (customer.companyDescription != null && customer.companyDescription!.isNotEmpty)
              Text('Company Description: ${customer.companyDescription!}'),
            if (customer.notes != null && customer.notes!.isNotEmpty)
              Text('Notes: ${customer.notes!}'),
            if (customer.addressLine1.isNotEmpty)
              Text('Address Line 1: ${customer.addressLine1}'),
            if (customer.addressLine2 != null && customer.addressLine2!.isNotEmpty)
              Text('Address Line 2: ${customer.addressLine2!}'),
            if (customer.gst != null && customer.gst!.isNotEmpty)
              Text('GST: ${customer.gst!}'),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(Icons.call, color: AppColors.icon, size: 32),
                  onPressed: () => _call(customer.phone),
                  tooltip: 'Call',
                ),
                IconButton(
                  icon: Icon(Icons.message, color: AppColors.icon, size: 32),
                  onPressed: () => _whatsapp(customer.phone),
                  tooltip: 'WhatsApp',
                ),
                IconButton(
                  icon: Icon(Icons.email, color: AppColors.icon, size: 32),
                  onPressed: () => _gmail(customer.email),
                  tooltip: 'Email',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
} 