import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';

class ForgetPasswordController extends GetxController {
  var isLoading = false.obs;
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmingPasswordController = TextEditingController();
  final isPasswordVisible = false.obs;
  final ApiServiceController _userService = ApiServiceController();

  @override
  void onInit() {
    super.onInit();
    fetchAndSetPhoneNumber();
  }

  void fetchAndSetPhoneNumber() async {
    try {
      isLoading.value = true;
      final user = await _userService.fetchUserProfile();
      phoneController.text = user.phoneNumber ?? '';
    } catch (e) {
      Get.snackbar("Error", "Failed to fetch user profile: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void updatePassword(String password) async {
    try {
      print('Starting password update...');
      isLoading.value = true;
      await _userService.updateEmployeeDetails(
          password,
          updateType: 'password',
          );
      print('Password update successful');
      Get.snackbar("Success", "Password updated successfully.");
    } catch (e) {
      print('Error: $e');
      Get.snackbar("Error", "Failed to update password: $e");
    } finally {
      print('Setting loading to false');
      isLoading.value = false;
    }


}


}

