
import 'package:idc_etus_bechar/controller/language_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LanguageScreen extends StatelessWidget {
  LanguageScreen({super.key});

  final LanguageController controller = Get.put(LanguageController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F5),
      body: Stack(
        children: [
          Positioned(
            top: 40,
            left: 20,
            right: 20,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "language".tr, // GetX translation
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "select_language".tr,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0,top:210),
            child: Expanded(
              child: ListView.builder(
                itemCount: controller.languages.length,
                itemBuilder: (context, index) {
                  final language = controller.languages[index];
                  final isSelected = controller.selectedLanguage.value == language['name'];

                  return GestureDetector(
                    onTap: () {
                      if (language['name'] != null && language['locale'] != null) {
                        controller.selectLanguage(language['name']!, language['locale']!);
                      }
                    },
                    child: Obx(() {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // SVG Card Background
                            ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: SvgPicture.asset(
                                color: isSelected ? AppColors.primary : Colors.white,
                                'assets/images/card_details.svg',
                                width: double.infinity,
                                height: 100,
                                fit: BoxFit.cover,
                              ),
                            ),
                            ListTile(
                              contentPadding: const EdgeInsets.all(16),
                              leading: Container(
                                width: controller.getCircleSize(language['name']!),
                                height: controller.getCircleSize(language['name']!),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: AssetImage(language['image']!),
                                    fit: BoxFit.cover,
                                  ),
                                  border: Border.all(
                                    color: isSelected ? Colors.white : Colors.transparent,
                                    width: 3,
                                  ),
                                ),
                              ),
                              title: Text(
                                language['name']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: isSelected ? Colors.white : Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

}
