import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:crm/app/controllers/auth_controller.dart';
import 'package:lottie/lottie.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:animate_do/animate_do.dart';


class LoginScreen extends StatelessWidget {
  final AuthController controller = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
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
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 40),
                FadeInDown(
                  duration: const Duration(milliseconds: 800),
                  child: Lottie.network(
                    'https://assets2.lottiefiles.com/packages/lf20_jcikwtux.json',
                    height: 180,
                    repeat: true,
                  ),
                ),
                FadeIn(
                  duration: const Duration(milliseconds: 900),
                  child: Text(
                    'Welcome Back!',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: theme.primaryColorDark,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                FadeIn(
                  duration: const Duration(milliseconds: 1000),
                  child: Text(
                    'Login to your account',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      color: Colors.grey[700],
                    ),
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
                        ToggleButtons(
                          isSelected: [
                            controller.isPasswordLogin.value,
                            !controller.isPasswordLogin.value
                          ],
                          onPressed: (index) {
                            controller.isPasswordLogin.value = index == 0;
                          },
                          borderRadius: BorderRadius.circular(12),
                          selectedColor: theme.primaryColor,
                          fillColor: theme.primaryColor.withOpacity(0.1),
                          children: const [
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("Password Login")),
                            Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text("OTP Login")),
                          ],
                        ),
                        const SizedBox(height: 20),
                        FadeInLeft(
                          duration: const Duration(milliseconds: 900),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: TextField(
                              onChanged: (val) => controller.email.value = val,
                              decoration: InputDecoration(
                                labelText: "Email",
                                labelStyle: GoogleFonts.poppins(),
                                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                prefixIcon: Icon(Icons.email_outlined),
                                fillColor: Colors.transparent,
                                filled: true,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        if (controller.isPasswordLogin.value)
                          FadeInRight(
                            duration: const Duration(milliseconds: 900),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: TextField(
                                obscureText: true,
                                onChanged: (val) => controller.password.value = val,
                                decoration: InputDecoration(
                                  labelText: "Password",
                                  labelStyle: GoogleFonts.poppins(),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                  prefixIcon: Icon(Icons.lock_outline),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                ),
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
                                    onPressed: () {
                                      if (controller.isPasswordLogin.value) {
                                        controller.login();
                                      } else {
                                        controller.sendOtpOnly();
                                      }
                                    },
                                    child: Text(controller.isPasswordLogin.value ? "Login" : "Send OTP"),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        )),
      ),
    );
  }
}
