
import 'package:idc_etus_bechar/controller/worker_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/details_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class WorkerDetails extends StatelessWidget {
  const WorkerDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final WorkerController controller = Get.put(WorkerController());
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    if (controller.selectedRole.value.isEmpty && controller.roles.isNotEmpty) {
      controller.selectedRole.value = controller.roles[0];
      controller.fetchEmployeesByRole(controller.roles[0]);
    }

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F5),
      body: SingleChildScrollView(
        child: SizedBox(
          height: screenHeight,
          child: Stack(
            children: [
              Positioned(
                left: 20,
                right: 20,
                top: 50,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        _buildIconContainer(Ionicons.notifications_outline),
                        const SizedBox(width: 5),
                        _buildProfileImage('assets/images/profile_img_test.png'),
                      ],
                    ),
                    // Title
                    Expanded(
                      child: Text(
                        'Worker Details ',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Role tabs
              Positioned(
                top: 120,
                left: 10,
                right: 10,
                child: Obx(() {
                  return controller.isLoading.value
                      ?  Center(child: SpinKitCircle(color: AppColors.primary, size: 25.0, ),)
                      : Container(
                    width: screenWidth,
                    height: 60,
                    decoration: BoxDecoration(
                      color: const Color(0xff133E87).withOpacity(0.42),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: controller.roles.length,
                      itemBuilder: (context, index) {
                        return _buildTab(
                          label: controller.roles[index],
                          isSelected: controller.selectedRole.value ==
                              controller.roles[index],
                          onTap: () {
                            controller.fetchEmployeesByRole(
                                controller.roles[index]);
                          },
                        );
                      },
                    ),
                  );
                }),
              ),
              Positioned(
                top: 210,
                left: 15,
                right: 15,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child:  SpinKitCircle(color: AppColors.primary, size: 25.0, ),);
                  } else if (controller.employees.isEmpty) {
                    return const Center(child: Text("No employees found."));
                  }
                  return SizedBox(
                    height: screenHeight - 250,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      itemCount: controller.employees.length,
                      itemBuilder: (context, index) {
                        var employee = controller.employees[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 15.0),
                          child: DetailsCard(
                            profileImage: "assets/images/profile_worker.png",
                            firstText: employee.name,
                            secondText: employee.email,
                            icon: Icons.phone,
                            onTap: () =>
                                _callPhoneNumber(employee.phoneNumber),
                          ),
                        );
                      },
                    ),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIconContainer(IconData icon) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: const Color(0xffCFCFCF),
          width: 0.8,
        ),
      ),
      child: Icon(
        icon,
        color: Colors.black,
        size: 22,
      ),
    );
  }

  Widget _buildProfileImage(String imagePath) {
    return GestureDetector(
      onTap: (){
        Get.toNamed('/account', arguments: "admin");
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xffCFCFCF),
            width: 0.8,
          ),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 30,
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF8AA1C8) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
          border: isSelected
              ? Border.all(color: Color(0xFF8AA1C8), width: 2)
              : null,
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.black,
          ),
        ),
      ),
    );
  }

  void _callPhoneNumber(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      print("Cannot launch dialer.");
    }
  }
}
