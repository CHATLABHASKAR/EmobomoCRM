import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:ui';
import '../../app/controllers/customer_controller.dart';
import '../../app/models/customer_model.dart';
import 'package:get_storage/get_storage.dart';
import '../../app/widgets/neon_glass_container.dart';
import '../../app/themes/app_colors.dart';

class CustomerFormScreen extends StatelessWidget {
  final CustomerModel? existingCustomer;
  CustomerFormScreen({Key? key})
      : existingCustomer = Get.arguments is CustomerModel ? Get.arguments as CustomerModel : null,
        super(key: key);

  final _formKey = GlobalKey<FormState>();
  final _companyController = TextEditingController();
  final _contactNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _altPhoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _gstController = TextEditingController();
  final _sourceController = TextEditingController();
  final _followUpDateController = TextEditingController();
  final _demoController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _companyDescriptionController = TextEditingController();
  final _notesController = TextEditingController();
  final _addressLine1Controller = TextEditingController();
  final _addressLine2Controller = TextEditingController();

  final List<String> sourceOptions = ['Website', 'Referral', 'Event', 'Other', 'Google', 'Manual', 'Justdial'];
  final List<String> demoOptions = ['Interested', 'Not Interested', 'Not Answered', 'Won', 'Lose', 'Yes', 'No'];

  @override
  Widget build(BuildContext context) {
    final CustomerController controller = Get.find<CustomerController>();
    final GetStorage _box = GetStorage();
    // Get logged-in user's name for Sales Contact
    final userData = _box.read('user');
    String salesContact = '';
    if (userData != null && userData is Map) {
      salesContact = userData['name'] ?? userData['user']?['name'] ?? '';
    }
    if (existingCustomer != null) {
      _companyController.text = existingCustomer!.companyName ?? '';
      _contactNameController.text = existingCustomer!.contactName;
      _phoneController.text = existingCustomer!.phone;
      _altPhoneController.text = existingCustomer!.alternativePhone ?? '';
      _emailController.text = existingCustomer!.email;
      _gstController.text = existingCustomer!.gst ?? '';
      _sourceController.text = existingCustomer!.source;
      _followUpDateController.text = existingCustomer!.followUpDate ?? '';
      _demoController.text = existingCustomer!.demo;
      _cityController.text = existingCustomer!.city;
      _stateController.text = existingCustomer!.state;
      _companyDescriptionController.text = existingCustomer!.companyDescription ?? '';
      _notesController.text = existingCustomer!.notes ?? '';
      _addressLine1Controller.text = existingCustomer!.addressLine1;
      _addressLine2Controller.text = existingCustomer!.addressLine2 ?? '';
      salesContact = existingCustomer!.salesContact;
    }
    return Center(
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        color: AppColors.card,
        child: Container(
          width: 420,
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    existingCustomer == null ? 'Add Customer' : 'Edit Customer',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _futuristicField(_companyController, 'Company Name*', 'Enter company name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_contactNameController, 'Contact Name*', 'Enter contact name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_phoneController, 'Phone*', 'Enter 10 digits', keyboardType: TextInputType.phone, validator: (v) => v == null || v.length != 10 ? 'Enter 10 digits' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_altPhoneController, 'Alternative Phone', 'Enter 10 digits', keyboardType: TextInputType.phone, validator: (v) => v != null && v.isNotEmpty && v.length != 10 ? 'Enter 10 digits' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_emailController, 'Email*', 'Enter email', keyboardType: TextInputType.emailAddress, validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_gstController, 'GST (optional)', 'Enter GST'),
                  const SizedBox(height: 14),
                  _futuristicField(_sourceController, 'Source*', 'Enter source', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_followUpDateController, 'Follow Up Date', 'Enter date'),
                  const SizedBox(height: 14),
                  _futuristicField(_demoController, 'Demo', 'Enter demo status'),
                  const SizedBox(height: 14),
                  _futuristicField(_cityController, 'City', 'Enter city'),
                  const SizedBox(height: 14),
                  _futuristicField(_stateController, 'State', 'Enter state'),
                  const SizedBox(height: 14),
                  _futuristicField(_companyDescriptionController, 'Company Description', 'Enter description'),
                  const SizedBox(height: 14),
                  _futuristicField(_notesController, 'Notes', 'Enter notes'),
                  const SizedBox(height: 14),
                  _futuristicField(_addressLine1Controller, 'Address Line 1', 'Enter address'),
                  const SizedBox(height: 14),
                  _futuristicField(_addressLine2Controller, 'Address Line 2', 'Enter address'),
                  const SizedBox(height: 18),
                  Obx(() => controller.isLoading.value
                      ? CircularProgressIndicator()
                      : ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            elevation: 8,
                            textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              final customer = CustomerModel(
                                id: existingCustomer?.id ?? '',
                                name: _contactNameController.text.trim(),
                                companyName: _companyController.text.trim(),
                                phone: _phoneController.text.trim(),
                                email: _emailController.text.trim(),
                                gst: _gstController.text.trim().isEmpty ? null : _gstController.text.trim(),
                                contactName: _contactNameController.text.trim(),
                                alternativePhone: _altPhoneController.text.trim().isEmpty ? null : _altPhoneController.text.trim(),
                                salesContact: salesContact,
                                source: _sourceController.text.trim(),
                                followUpDate: _followUpDateController.text.trim().isEmpty ? null : _followUpDateController.text.trim(),
                                demo: _demoController.text.trim(),
                                city: _cityController.text.trim(),
                                state: _stateController.text.trim(),
                                companyDescription: _companyDescriptionController.text.trim().isEmpty ? null : _companyDescriptionController.text.trim(),
                                notes: _notesController.text.trim().isEmpty ? null : _notesController.text.trim(),
                                addressLine1: _addressLine1Controller.text.trim(),
                                addressLine2: _addressLine2Controller.text.trim().isEmpty ? null : _addressLine2Controller.text.trim(),
                              );
                              await controller.addOrEditCustomer(customer, isEdit: existingCustomer != null);
                              Get.back();
                            }
                          },
                          child: Text(existingCustomer == null ? 'Add Customer' : 'Update Customer'),
                        )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _futuristicField(
    TextEditingController controller,
    String label,
    String hint, {
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
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
} 