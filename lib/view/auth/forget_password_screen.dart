import 'dart:ui';
import 'package:idc_etus_bechar/controller/forget_password_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ForgetPasswordScreen extends StatefulWidget {
  const ForgetPasswordScreen({super.key});

  @override
  State<ForgetPasswordScreen> createState() => _ForgetPasswordScreenState();
}

class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForgetPasswordController());


    return Obx(() {
      return Scaffold(
        backgroundColor: const Color(0xFFEEF2F5),
        body: SingleChildScrollView(
          padding: const EdgeInsets.only(left: 25, right: 25, top: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InkWell(
                onTap: () {
                  Get.toNamed('/account');
                },
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: const Icon(
                    Ionicons.chevron_back_outline,
                    color: Colors.grey,
                    size: 24,
                  ),
                ),
              ),
              // Main UI when not loading
              if (!controller.isLoading.value)
                    Positioned(
                      left: 25, right: 25, top: 30,
                      child: Form(
                        key: _formKey,  // Added FormKey here
                        child: Column(
                          children: [
                            _buildLogo(),
                            const SizedBox(height: 15),
                            _buildWelcomeText(context),
                            const SizedBox(height: 32),
                            _buildPhoneField(controller),
                            const SizedBox(height: 16),
                            _buildPasswordField(controller),
                            const SizedBox(height: 16),
                            _buildConfirmingPasswordField(controller),
                            const SizedBox(height: 42),
                            _buildSignInButton(controller),
                          ],
                        ),
                      ),
                    ),
                    if (controller.isLoading.value)
                      Stack(
                        children: [
                          Container(
                            color: Colors.black54, // Darken the background
                          ),
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur
                            child: Container(
                              color: Colors.transparent, // Ensure transparency
                            ),
                          ),
                          Center(
                            child: CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                  ],

                ),
              // Circular progress overlay when loading

        ),
      );
    });
  }

  Widget _buildLogo() {
    return Image.asset(
      'assets/images/logo.png',
      width: 120,
      height: 120,
    );
  }

  Widget _buildWelcomeText(BuildContext context) {
    return Column(
      children: [
        Text(
          "welcome_to_etus_auto_bus".tr,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 19,
            color: Colors.black,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        Text(
          "update_password_using_phone_number".tr,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: Colors.grey,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildPhoneField(ForgetPasswordController controller) {
    return TextFormField(
      controller: controller.phoneController,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
      decoration: _inputDecoration(
        hintText: "enter_phone_number".tr,
        icon: Icons.phone,
      ),
    );
  }

  Widget _buildPasswordField(ForgetPasswordController controller) {
    return Obx(() {
      return TextFormField(
        controller: controller.passwordController,
        obscureText: !controller.isPasswordVisible.value,
        decoration: _inputDecoration(
          hintText: "enter_password".tr,
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
      );
    });
  }

  Widget _buildConfirmingPasswordField(ForgetPasswordController controller) {
    return Obx(() {
      return TextFormField(
        controller: controller.confirmingPasswordController,
        obscureText: !controller.isPasswordVisible.value,
        decoration: _inputDecoration(
          hintText: "confirm_password".tr,
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
      );
    });
  }

  Widget _buildSignInButton(ForgetPasswordController controller) {
    return SizedBox(
      width: 210,
      height: 50,
      child: ElevatedButton(
        onPressed: () {
          // Check if the form is valid
          if (_formKey.currentState?.validate() == true) {
            print('Button Pressed'); // Debug
            if (controller.passwordController.text.trim() !=
                controller.confirmingPasswordController.text.trim()) {
              Get.snackbar( "error".tr, "passwords_do_not_match".tr);
            } else {
              print('Updating Password'); // Debug
              controller.updatePassword(
                controller.passwordController.text.trim(),
              );
            }
          } else {
            Get.snackbar("error".tr, "please_fill_out_required_fields".tr);
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
          "updating_password".tr,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }



  InputDecoration _inputDecoration({required String hintText, required IconData icon, Widget? suffixIcon}) {
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
}