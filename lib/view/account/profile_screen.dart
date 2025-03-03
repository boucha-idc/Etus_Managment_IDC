import 'package:idc_etus_bechar/controller/profile_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/dashes_line.dart';
import 'package:idc_etus_bechar/widgets/rapport_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final ProfileController controller = Get.put(ProfileController());

    return Scaffold(
      backgroundColor:  const Color(0xFFEEF2F5),
      body: Stack(
        children: [
          Padding(
              padding: const EdgeInsets.only(top: 60,left: 20,right:20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Align items to the left
                children: [
                  InkWell(
                    onTap: () {
                      Get.toNamed('/scanQR');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15), // Border radius
                      ),
                      padding: const EdgeInsets.all(8), // Padding inside the container
                      child: const Icon(
                        Ionicons.chevron_back_outline, // Left arrow icon
                        color: Colors.grey, // Icon color
                        size: 24,
                      ),
                    ),
                  ),
                  Text(
                    "mon_profile".tr,
                    textAlign: TextAlign.center, // Center the text
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      fontSize: 20, // Adjust font size as needed
                      color: Colors.black, // Adjust color if needed
                    ),
                  ),
                  InkWell(
                    onTap: () {

                      Get.toNamed('/account', arguments: "controller");
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15), // Border radius
                      ),
                      padding: const EdgeInsets.all(8), // Padding inside the container
                      child: const Icon(
                        Ionicons.settings_outline,
                        color: Colors.grey,
                        size: 24,
                      ),
                    ),
                  ),

                ],
              )

          ),
          Column(
            children: [
              const SizedBox(height: 120),
              Align(
                alignment: Alignment.center,
                child: _buildImageProfile(),
              ),
              const SizedBox(height: 5),
              Obx(() {
                if (controller.isLoading.value) {
                  return const CircularProgressIndicator();  // Show loading spinner while fetching data
                } else {
                  return Text(
                    controller.userName.value.isNotEmpty ? controller.userName.value : "Loading...",
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  );
                }
              }),
              const SizedBox(height: 1),
              Obx(() {
                return Text(
                  controller.userEmail.value.isNotEmpty ? controller.userEmail.value : "Loading...",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.grey,
                  ),
                );
              }),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Obx(() => _buildColumn("${controller.reportCount.value}", "total_reports".tr)),
                    const SizedBox(
                      height: 50,
                      width: 2,
                      child: DashedLine(
                        direction: Axis.vertical,
                        dashLength: 4.0,
                        dashGap: 2.0,
                        thickness: 2.0,
                        color: Colors.black,
                      ),
                    ),
                    Obx(() => _buildColumn("${controller.busCount.value}", "bus_controlled".tr)),
                  ],
                ),
              ),
              const SizedBox(height: 50),
              /*const Padding(
                padding: EdgeInsets.only(left: 30,right: 190),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "List Raport ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                     Padding(
                       padding: EdgeInsets.only(top: 4),
                       child: SizedBox(
                        height: 2,
                        width: 120,
                        child:Divider(
                          color: Colors.black26,  // Line color
                          thickness: 2.0,  // Line thickness
                        )
                                         ),
                     ),
                  ],
                ),
              ),*/
              SizedBox(
                height: 300,
                child: Obx(() {
                  if (controller.isReportsLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (controller.controllerReports.isEmpty) {
                    return const Center(child: Text("No reports available."));
                  }
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.controllerReports.length,
                    itemBuilder: (context, index) {
                      var report = controller.controllerReports[index];
                      return GestureDetector(
                        onTap: () {
                          Get.toNamed('/dialog_rapport');
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: RapportCard(report: report),
                        ),
                      );
                    },
                  );
                })

              )

            ],
          ),
        ],
      ),
    );
  }

  Container _buildImageProfile() {
    return Container(
      width: 130,
      height: 130,
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: const Color(0xFFDDDDE5),
          width: 1,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Image.asset(
          'assets/images/profile_img_test.png',
          width: 120,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Column _buildColumn(String value, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.displayLarge?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
