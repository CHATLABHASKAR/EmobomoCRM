import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../app/controllers/onboarding_controller.dart';
import '../../app/models/employee_model.dart';
import '../../app/widgets/neon_glass_container.dart';
import '../../app/themes/app_colors.dart';

class OnboardEmployeeScreen extends StatelessWidget {
  final OnboardingController controller = Get.put(OnboardingController());
  final _employeeIdController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _employeeAddressController = TextEditingController();
  final _officeAddressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _personalEmailController = TextEditingController();
  final _professionalEmailController = TextEditingController();
  final _phoneNumberController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final EmployeeModel? employee = Get.arguments as EmployeeModel?;
    if (employee != null) {
      // Only prefill fields that exist in EmployeeModel
      _firstNameController.text = employee.firstName;
      _lastNameController.text = employee.lastName;
      _phoneNumberController.text = employee.phoneNumber;
      // _employeeIdController.text = employee.employeeId; // Not in model
      // _employeeAddressController.text = employee.employeeAddress; // Not in model
      // _officeAddressController.text = employee.officeAddress; // Not in model
      // _passwordController.text = employee.password; // Not in model
      // _personalEmailController.text = employee.personalEmail; // Not in model
      // _professionalEmailController.text = employee.professionalEmail; // Not in model
      controller.model.roleName = employee.roleName;
      controller.model.joiningDate = employee.joiningDate;
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
            key: controller.formKeys[0],
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Add the header
                Padding(
                  padding: const EdgeInsets.only(bottom: 24.0),
                  child: Text(
                    'Onboarding Employee',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: AppColors.primary.withOpacity(0.18),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                  ),
                ),
                _futuristicField(
                  _employeeIdController,
                  'Employee Id',
                  'Enter employee ID',
                  keyboardType: TextInputType.text,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _firstNameController,
                  'First Name',
                  'Enter first name',
                  keyboardType: TextInputType.text,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _lastNameController,
                  'Last Name',
                  'Enter last name',
                  keyboardType: TextInputType.text,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _styledDatePickerField(
                  label: 'Date Of Birth',
                  onSaved: (date) => controller.model.dateOfBirth = date,
                ),
                const SizedBox(height: 14),
                _styledDatePickerField(
                  label: 'Joining Date',
                  onSaved: (date) => controller.model.joiningDate = date,
                ),
                const SizedBox(height: 14),
                _styledDatePickerField(
                  label: 'Termination Date',
                  onSaved: (date) => controller.model.terminationDate = date,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _employeeAddressController,
                  'Employee Address',
                  'Enter employee address',
                  keyboardType: TextInputType.text,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _officeAddressController,
                  'Office Address',
                  'Enter office address',
                  keyboardType: TextInputType.text,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _passwordController,
                  'Password',
                  'Enter password',
                  keyboardType: TextInputType.text,
                  obscureText: true,
                  validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _personalEmailController,
                  'Personal Email',
                  'Enter personal email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _professionalEmailController,
                  'Professional Email',
                  'Enter professional email',
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v == null || !v.contains('@') ? 'Enter valid email' : null,
                ),
                const SizedBox(height: 14),
                _futuristicField(
                  _phoneNumberController,
                  'Phone Number',
                  'Enter phone number',
                  keyboardType: TextInputType.phone,
                  validator: (v) => v == null || v.length < 10 ? 'Enter valid phone' : null,
                ),
                const SizedBox(height: 14),
                // Styled Dropdown for Role
                Obx(() => controller.loadingRoles.value
                        ? Center(child: CircularProgressIndicator())
                        : controller.roles.isEmpty
                            ? Text('No roles available')
                            : DropdownButtonFormField<String>(
                                decoration: InputDecoration(
                                  labelText: 'Role',
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
                                items: controller.roles.entries
                                    .map((entry) => DropdownMenuItem(
                                          value: entry.key,
                                          child: Text(entry.value),
                                        ))
                                    .toList(),
                                validator: (v) => v == null ? 'Select role' : null,
                                onChanged: (v) => controller.model.roleName = v,
                              )),
                const SizedBox(height: 24),
                // Styled submit button
                Obx(() => ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    elevation: 8,
                    textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  onPressed: controller.isSubmitting.value ? null : controller.submit,
                  child: controller.isSubmitting.value
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('Submitting...'),
                          ],
                        )
                      : Text('Submit'),
                )),
              ],
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
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      validator: validator,
      obscureText: obscureText,
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

class DatePickerField extends StatefulWidget {
  final String label;
  final void Function(String?) onSaved;
  final InputDecoration? decoration; // Added decoration parameter
  DatePickerField({required this.label, required this.onSaved, this.decoration}); // Added decoration parameter
  @override
  _DatePickerFieldState createState() => _DatePickerFieldState();
}

class _DatePickerFieldState extends State<DatePickerField> {
  String? selectedDate;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      readOnly: true,
      decoration: widget.decoration ?? // Use the provided decoration or default
          InputDecoration(
            labelText: widget.label,
            suffixIcon: Icon(Icons.calendar_today, color: AppColors.text),
          ),
      controller: TextEditingController(
        text: selectedDate ?? '',
      ),
      validator: (v) => selectedDate == null ? 'Select date' : null,
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(1950),
          lastDate: DateTime(2100),
        );
        if (picked != null) setState(() => selectedDate = picked.toIso8601String().split('T').first);
      },
      onSaved: (v) => widget.onSaved(selectedDate),
    );
  }
}

// Add this helper for styled date picker fields
Widget _styledDatePickerField({required String label, required void Function(String?) onSaved}) {
  return DatePickerField(
    label: label,
    onSaved: onSaved,
    decoration: InputDecoration(
      labelText: label,
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