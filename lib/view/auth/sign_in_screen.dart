import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/controller/sign_in_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final controller = Get.put(SignInController());

  final _formKey = GlobalKey<FormState>();


  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Stack(
        children: [
          Scaffold(
            backgroundColor: const Color(0xFFEEF2F5),
            body: Padding(
              padding: const EdgeInsets.only(left: 25, right: 25, top: 50),
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildLogo(),
                      _buildWelcomeText(context),
                      const SizedBox(height: 22),
                      _buildPhoneField(),
                      const SizedBox(height: 16),
                      _buildPasswordField(),
                      const SizedBox(height: 32),
                      _buildSignInButton(context),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (controller.isLoading.value)
            Stack(
              children: [
                Container(
                  color: Colors.black54,
                ),
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                  child: Container(
                    color: Colors.transparent,
                  ),
                ),
                Center(
                  child: CircularProgressIndicator(
                    valueColor:
                    AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
              ],
            ),
        ],
      );
    });
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/icon/logo_etus.png',
      width: 220,
      height: 170,
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          'Welcome to ETUS Auto Bus',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          'Sign in using your phone number',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 14,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneField() {
    return TextFormField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: _inputDecoration(
        hintText: 'Enter your phone number',
        icon: Icons.phone,
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          _showError("Please enter your phone number.");
          return '';
        }
        if (value.length != 10) {
          _showError("The phone number must be 10 digits long.");
          return '';
        }
        return null;
      },
    );
  }

  Widget _buildPasswordField() {
    return Obx(() {
      return TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        decoration: _inputDecoration(
          hintText: 'Enter your password',
          icon: Icons.lock,
          suffixIcon: IconButton(
            icon: Icon(
              controller.isPasswordVisible.value
                  ? Icons.visibility
                  : Icons.visibility_off,
            ),
            onPressed: () {
              controller.isPasswordVisible.value =
              !controller.isPasswordVisible.value;
            },
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            _showError("Please enter your password.");
            return '';
          }
          if (value.length < 6) {
            _showError("The password must be at least 6 characters long.");
            return '';
          }
          return null;
        },
      );
    });
  }

  Widget _buildSignInButton(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          if (_formKey.currentState?.validate() == true) {
            controller.signIn(
              controller.phoneController.text.trim(),
              controller.passwordController.text.trim(),
            );
          }
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(40),
            side: BorderSide(color: AppColors.primary),
          ),
          backgroundColor: AppColors.primary,
        ),
        child: Text(
          'Sign In',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hintText, required IconData icon, Widget? suffixIcon, }) {
    return InputDecoration(
      prefixIcon: Padding(
        padding: const EdgeInsets.all(12.0),
        child: CircleAvatar(
          radius: 16,
          backgroundColor: AppColors.primary,
          child: Icon(icon, color: Colors.white),
        ),
      ),
      suffixIcon: suffixIcon,
      hintText: hintText,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(20),
        borderSide: BorderSide(color: AppColors.primary),
      ),
    );
  }

  void _showError(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.transparent,
      colorText: Colors.black,
      borderRadius: 20.0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderWidth: 2,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }
}
