import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:idc_etus_bechar/services/api_services_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInController extends GetxController {
  final ApiServiceAuth apiService = ApiServiceAuth();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  var isPasswordVisible = false.obs;
  var isLoading = false.obs;
  var errorMessage = "".obs;

  Future<void> signIn(String phoneNumber, String password) async {
    if (phoneNumber.isEmpty || password.isEmpty) {
      errorMessage.value = "Please fill in all the fields.";
      return;
    }

    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.wifi) {
      Get.snackbar(
        "No Wi-Fi Connection",
        "Please connect to Wi-Fi to proceed.",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = "";

      final result = await apiService.signIn(phoneNumber, password);

      if (result != null && result['success'] == true) {
        print("Login successful: $result");

        final prefs = await SharedPreferences.getInstance();
        final token = result['token'];
        await prefs.setString('auth_token', token);

        final username = result['employee']['name'] ?? 'User';
        final role = result['employee']['role'] ?? '';

        Get.snackbar(
          "Welcome Back",
          "$username!",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.transparent,
          colorText: Colors.black,
        );

        if (role.toLowerCase() == 'controller') {
          Get.offNamed('/scanQR');
        } else if (role.toLowerCase() == 'admin') {
          Get.offNamed('/HomePage');
        } else {
          await performOtherAction();
        }
      } else {
        errorMessage.value = "Login failed. Please try again.";
      }
    } catch (e) {
      if (e.toString().contains('401')) {
        errorMessage.value = "Invalid phone number or password.";
      } else {
        errorMessage.value = "An error occurred: ${e.toString()}";
      }
      Get.snackbar(
        "Login Error",
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }


  Future<void> performOtherAction() async {
    Get.snackbar(
      "Access Denied",
      "You do not have the necessary permissions.",
      snackPosition: SnackPosition.TOP,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      borderRadius: 20.0,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      borderWidth: 2,
      duration: const Duration(seconds: 3),
      isDismissible: true,
      forwardAnimationCurve: Curves.easeOutBack,
    );
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
