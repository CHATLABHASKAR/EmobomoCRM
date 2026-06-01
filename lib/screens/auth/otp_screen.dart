import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:crm/app/controllers/auth_controller.dart";
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatelessWidget {
  final controller = Get.find<AuthController>();
  final TextEditingController otpInput = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Enter OTP", style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: theme.primaryColorDark,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFe0eafc), Color(0xFFcfdef3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Obx(() => SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_ktwnwv5m.json',
                    height: 140,
                    repeat: true,
                  ),
                ),
                const SizedBox(height: 16),
                FadeIn(
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    'We have sent an OTP to your email',
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.92),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 24,
                          offset: Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FadeInLeft(
                          duration: const Duration(milliseconds: 900),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: PinCodeTextField(
                              appContext: context,
                              length: 6,
                              controller: otpInput,
                              animationType: AnimationType.fade,
                              pinTheme: PinTheme(
                                shape: PinCodeFieldShape.box,
                                borderRadius: BorderRadius.circular(10),
                                fieldHeight: 50,
                                fieldWidth: 40,
                                activeFillColor: Colors.white,
                                selectedFillColor: Colors.blue[50],
                                inactiveFillColor: Colors.grey[200],
                                activeColor: theme.primaryColor,
                                selectedColor: theme.primaryColorDark,
                                inactiveColor: Colors.grey,
                                borderWidth: 1.5,
                              ),
                              animationDuration: const Duration(milliseconds: 300),
                              enableActiveFill: true,
                              keyboardType: TextInputType.number,
                              onChanged: (value) {},
                              onCompleted: (value) {
                                controller.verifyOtp(value);
                              },
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        controller.isLoading.value
                          ? CircularProgressIndicator()
                          : FadeInUp(
                              duration: const Duration(milliseconds: 900),
                              child: SizedBox(
                                width: double.infinity,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.8),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      padding: const EdgeInsets.symmetric(vertical: 16),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      textStyle: GoogleFonts.poppins(fontWeight: FontWeight.bold, fontSize: 16),
                                    ),
                                    onPressed: () => controller.verifyOtp(otpInput.text),
                                    child: Text("Verify"),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
