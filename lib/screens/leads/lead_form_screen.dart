import 'package:crm/app/models/leads_model.dart';
import 'package:crm/app/utils/dynamic_form_builder.dart';
import 'package:flutter/material.dart';
import '../../app/widgets/futuristic_app_bar.dart';
import 'package:get/get.dart';
import '../../app/themes/app_colors.dart';


class LeadFormScreen extends StatelessWidget {
  final LeadModel? existingLead;
  LeadFormScreen({this.existingLead});

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _statusController = TextEditingController();
  final _sourceController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (existingLead != null) {
      _nameController.text = existingLead!.name;
      _emailController.text = existingLead!.email;
      _phoneController.text = existingLead!.phone;
      _statusController.text = existingLead!.status;
      _sourceController.text = existingLead!.source;
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
                    existingLead == null ? 'Add Lead' : 'Edit Lead',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 18),
                  _futuristicField(_nameController, 'Name*', 'Enter name', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_emailController, 'Email*', 'Enter email', keyboardType: TextInputType.emailAddress, validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_phoneController, 'Phone*', 'Enter phone', keyboardType: TextInputType.phone, validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_statusController, 'Status*', 'Enter status', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _futuristicField(_sourceController, 'Source*', 'Enter source', validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 18),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                      elevation: 8,
                      textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        final lead = LeadModel(
                          id: existingLead?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                          name: _nameController.text.trim(),
                          email: _emailController.text.trim(),
                          phone: _phoneController.text.trim(),
                          status: _statusController.text.trim(),
                          source: _sourceController.text.trim(),
                        );
                        Navigator.pop(context, lead);
                      }
                    },
                    child: Text(existingLead == null ? 'Add Lead' : 'Update Lead'),
                  ),
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