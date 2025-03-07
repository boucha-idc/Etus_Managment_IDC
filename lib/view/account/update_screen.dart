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
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../utils/app_colors.dart';
class UpdateAccountScreen extends StatefulWidget {
  const UpdateAccountScreen({Key? key}) : super(key: key);

  @override
  _UpdateAccountScreenState createState() => _UpdateAccountScreenState();
}

class _UpdateAccountScreenState extends State<UpdateAccountScreen> with WidgetsBindingObserver{
  final UpdateAccountController controller = Get.put(UpdateAccountController());
  File? _image;
  final ImagePicker _picker = ImagePicker();
  String? imageUrl;
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;
  @override
  void initState() {
    super.initState();
    controller.fetchUserProfile();
    _nameController = TextEditingController(text: controller.user.value?.name?? '');
    _roleController = TextEditingController(text: controller.user.value?.role ?? '');
    _phoneController = TextEditingController(text: controller.user.value?.phoneNumber ?? '');
    _emailController = TextEditingController(text: controller.user.value?.email ?? '');
    ever(controller.user, (user) {
      setState(() {
        if (user?.image != null && user!.image!.isNotEmpty) {
          imageUrl = Uri.parse(user.image!).toString();
        } else {
          imageUrl = "";
        }
        _nameController.text = user?.name ?? '';
        _roleController.text = user?.role ?? '';
        _phoneController.text = user?.phoneNumber ?? '';
        _emailController.text = user?.email ?? '';
      });
    });
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _nameController.dispose();
    _roleController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.fetchUserProfile();
    }}


  Future<void> _checkPermissions() async {
    if (await Permission.photos.request().isGranted) {
      _pickImage();
    } else {
      print("Permission denied.");
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
                        Get.toNamed('/account', arguments: controller.user.value?.role ?? '');
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
                    ? SpinKitCircle(color: AppColors.primary, size: 25.0)
                    : Column(
                  children: [
                    UpdateItem(
                      title: "Photo",
                      widget: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
                              if (pickedFile != null) {
                                controller.imageFile.value = File(pickedFile.path);
                              }
                            },
                            child: Column(
                              children: [
                                Obx(() {
                                  return ClipOval(
                                    child: controller.imageFile.value != null
                                        ? Image.file(
                                      controller.imageFile.value!,
                                      height: 100,
                                      width: 100,
                                      fit: BoxFit.cover,
                                    )
                                        : Image.network(
                                      controller.user.value?.image ?? '',
                                       height: 100,
                                       width: 100,
                                       fit: BoxFit.cover,
                                       errorBuilder: (context, error, stackTrace) {
                                        return Image.asset(
                                          "assets/images/profile_img_test.png",
                                          height: 100,
                                          width: 100,
                                          fit: BoxFit.cover,
                                        );
                                      },
                                    ),
                                  );
                                }),




                                const SizedBox(height: 8),
                                Text(
                                  "Upload Image",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color:AppColors.primary,
                                    fontWeight: FontWeight.bold,
                                     // Underlined text
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Other fields (Name, Role, Phone, Email, Save button)
                    UpdateItem(
                      title: "Name",
                      widget: TextField(
                        controller: TextEditingController(text: _nameController.text),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      title: "Role",
                      widget: TextField(
                        controller: TextEditingController(text: _roleController.text),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      title: "Phone",
                      widget: TextField(
                        controller: TextEditingController(text:  _phoneController.text),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                    UpdateItem(
                      title: "Email",
                      widget: TextField(
                        controller: TextEditingController(text: _emailController.text),
                        readOnly: true,
                        style: const TextStyle(
                          color: Colors.grey,
                        ),
                      ),
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
              })


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
