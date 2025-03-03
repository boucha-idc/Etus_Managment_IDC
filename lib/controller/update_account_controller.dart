import 'dart:io';
import 'dart:convert';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:idc_etus_bechar/models/user.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';

class UpdateAccountController extends GetxController {
  final ApiServiceController _userService = ApiServiceController();

  var user = Rx<User?>(null);
  var gender = "man".obs;
  var imageFile = Rx<File?>(null);
  var imageUrl = "".obs; // Store the uploaded image URL
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  /// Fetch User Profile
  Future<void> fetchUserProfile() async {
    try {
      user.value = await _userService.fetchUserProfile();
      if (user.value != null && user.value!.image.isNotEmpty) {
        imageUrl.value = user.value!.image;
      }
    } catch (e) {
      print("Error fetching profile: $e");
    }
  }

  /// Pick Image from Gallery
  Future<void> pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      imageFile.value = File(pickedFile.path);
      print("Image selected: ${pickedFile.path}");
    } else {
      print("No image selected");
    }
  }

  Future<void> updateUserProfile() async {
    isLoading.value = true;
    try {
      if (imageFile.value == null) {
        print("No image selected. Ask user to pick one!");
        Get.snackbar("Error", "Please select an image before updating.");
        return;
      }

      await _userService.updateEmployeeDetails(
        "",
        updateType: 'image',
        imageFile: imageFile.value!,
      );

      Get.snackbar("Success", "Profile image updated successfully.");
    } catch (e) {
      print("Error updating profile: $e");
      Get.snackbar("Error", "Failed to update profile: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<String> _encodeImageToBase64(File imageFile) async {
    try {
      final compressedBytes = await FlutterImageCompress.compressWithFile(
        imageFile.absolute.path,
        quality: 50,
      );

      if (compressedBytes == null) {
        print("Compression failed, returning empty string.");
        return "";
      }

      return base64Encode(compressedBytes);
    } catch (e) {
      print("Error encoding image: $e");
      return "";
    }
  }
/*Future<String> _uploadImage(File imageFile) async {
  return "https://idevelopcompany.dz/IDC%20Projects/BusManagement/storage/${imageFile.path.split('/').last}";
}*/

}
