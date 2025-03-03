import 'dart:io';
import 'dart:ui';
import 'package:idc_etus_bechar/controller/update_account_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/widgets/update_Item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> {
  final UpdateAccountController controller = Get.put(UpdateAccountController());
  File? _image;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile();
  }

  Future<void> _checkPermissions() async {
    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted) {
        await _pickImage();
      } else {
        await Permission.photos.request();
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });

        controller.imageFile.value = File(pickedFile.path);
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEEF2F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 40),
                child: Row(
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
                    const SizedBox(width: 25),
                    const Text(
                      "Account",
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Obx(() {
                return controller.user.value == null
                    ? CircularProgressIndicator()
                    : Column(
                  children: [
                    UpdateItem(
                      title: "Photo",
                      widget: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: _image == null
                                ? (controller.user.value!.image?.isEmpty ?? true
                                ? Image.asset(
                              'assets/images/profile_img_test.png',
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            )
                                : Image.network(
                              controller.user.value!.image != null
                                  ? Uri.encodeFull(controller.user.value!.image!)
                                  : "",
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      value: loadingProgress.expectedTotalBytes != null
                                          ? loadingProgress.cumulativeBytesLoaded /
                                          (loadingProgress.expectedTotalBytes ?? 1)
                                          : null,
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Image.asset(
                                  'assets/images/profile_img_test.png',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                );
                              },
                            ))
                                : Image.file(
                              _image!,
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),


                          TextButton(
                            onPressed: _checkPermissions,
                            style: TextButton.styleFrom(
                              foregroundColor: AppColors.primary,
                            ),
                            child: const Text("Upload Image"),
                          ),
                        ],
                      ),
                    ),
                     UpdateItem(
                      title: "Name",
                      widget: TextField(
                        controller: TextEditingController(text: controller.user.value?.name),
                        readOnly: true,
                        style:const  TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      widget: TextField(
                        controller: TextEditingController(text: controller.user.value?.role),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      title: "Role",
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      widget: TextField(
                        controller: TextEditingController(text: controller.user.value?.phoneNumber),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      title: "Phone",
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      widget: TextField(
                        controller: TextEditingController(text: controller.user.value?.email),
                        readOnly: true,
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                      title: "Email",
                    ),
                    const SizedBox(height: 40),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 120,
                          height: 48,
                          child: ElevatedButton(
                            onPressed: () {
                              controller.updateUserProfile();
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(40),
                                side: BorderSide(color: AppColors.primary),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 16.0),
                              backgroundColor: AppColors.primary,
                            ),
                            child: Text(
                              'Save',
                              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              }),
            ],
          ),
        ),
      ),
      floatingActionButton: Obx(() {
        return controller.isLoading.value
            ? Stack(
          children: [
            Container(
              color: Colors.black54
            ),
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0), // Blur
              child: Container(
                color: Colors.transparent,
              ),
            ),
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
              ),
            ),
          ],
        )
            : Container();
      }),
    );
  }
}
