
import 'package:idc_etus_bechar/controller/profile_controller.dart';
import 'package:idc_etus_bechar/view/account/update_screen.dart';
import 'package:idc_etus_bechar/widgets/forward_button.dart';
import 'package:idc_etus_bechar/widgets/setting_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {

  final ProfileController controller = Get.put(ProfileController());
  String encodedUrl ="";
  @override
  void initState() {
        super.initState();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          String imageValue = controller.image.value;

          if (imageValue != null && imageValue.isNotEmpty) {
            // Decode and encode the URL properly
            String decodedUrl = imageValue.replaceAll(r'\/', '/');
            encodedUrl = Uri.encodeFull(decodedUrl);
          }
          setState(() {});
        });
      }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:  Color(0xFFEEF2F5),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top:40,left:30,right:30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Row(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 mainAxisAlignment: MainAxisAlignment.start,
                 children: [
                   InkWell(
                     onTap: () {
                       final String currentRole = Get.arguments;
                       if (currentRole == "admin") {
                         Get.toNamed('/HomePage');
                       } else {
                         Get.toNamed('/profile');
                       }
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
                   Text(
                    "settings".tr,
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                                 ),
                 ],
               ),
              const SizedBox(height: 40),
              const Text(
                "Account",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(50),
                      child: encodedUrl != null && encodedUrl.isNotEmpty
                          ? Image.network(
                        encodedUrl,
                        width: 60,
                        height: 60,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset("assets/images/profile_img_test.png",
                              width: 60, height: 60, fit: BoxFit.cover);
                        },
                      )
                          : Image.asset(
                        "assets/images/profile_img_test.png",
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                      ),

                    ),
                    const SizedBox(width: 20),
                     Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userName.value,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 10),
                        // Display the user's role
                        Text(
                          controller.userRole.value,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    ForwardButton(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>  UpdateAccountScreen(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
              const SizedBox(height: 40),
              Text(
                "settings".tr,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 20),
          SettingItem(
            title: "language".tr,
            icon: Ionicons.earth,
            bgColor: Colors.orange.shade100,
            iconColor: Colors.orange,
            value: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Current selected language text
                Text(
                  _getCurrentLanguage(),
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ), onTap: () {
            _showLanguageSelection(context);
          },
          ),


              const SizedBox(height: 20),
              SettingItem(
                title: "password".tr,
                icon: Ionicons.lock_closed,
                bgColor: Colors.blue.shade100,
                iconColor: Colors.blue,
                onTap: () {
                  Get.toNamed('/forgot_password');

                },
              ),
              const SizedBox(height: 20),
              SettingItem(
                title: "log_out".tr,
                icon: Ionicons.log_out,
                bgColor: Colors.red.shade100,
                iconColor: Colors.red,
                onTap: () async {
                  // Call the logout function
                  await controller.logout();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _changeLanguage(String languageCode) {
    Get.updateLocale(Locale(languageCode));
  }

  String _getCurrentLanguage() {
    switch (Get.locale?.languageCode) {
      case 'ar':
        return 'Arabic';
      case 'fr':
        return 'French';
      default:
        return 'English';
    }
  }

  void _showLanguageSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Wrap(
          children: [
            ListTile(
              leading: Icon(Icons.language),
              title: Text("English"),
              onTap: () {
                _changeLanguage('en'); // Change to English
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("Arabic"),
              onTap: () {
                _changeLanguage('ar'); // Change to Arabic
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
            ListTile(
              leading: Icon(Icons.language),
              title: Text("French"),
              onTap: () {
                _changeLanguage('fr'); // Change to French
                Navigator.pop(context); // Close the bottom sheet
              },
            ),
          ],
        );
      },
    );
  }}