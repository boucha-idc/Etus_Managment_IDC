
import 'package:idc_etus_bechar/controller/bus_rapport_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/custom_bus_painter.dart';
import 'package:idc_etus_bechar/widgets/dashes_line.dart';
import 'package:idc_etus_bechar/widgets/dropdown_option_rapport.dart';
import 'package:idc_etus_bechar/widgets/radio_list_rapport.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class BusEvaluationScreen extends StatefulWidget {
  String? reference;

  BusEvaluationScreen({super.key, this.reference});

  @override
  State<BusEvaluationScreen> createState() => _BusEvaluationScreenState();
}

class _BusEvaluationScreenState extends State<BusEvaluationScreen> {
  @override
  Widget build(BuildContext context) {
    final BusRapportController controller = Get.put(BusRapportController());
    final Map<String, dynamic> arguments = Get.arguments;
    final String reference = arguments['reference']as String? ?? "No Reference";
    final int busId = arguments['busId'];
    String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
    double screenWidth = MediaQuery.of(context).size.width;
    final TextEditingController _ObservationController =
    TextEditingController();

    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              ClipRect(
                child: Align(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/images/scan_pic.jpg',
                    fit: BoxFit.cover,
                    width: constraints.maxWidth,
                    height: constraints.maxHeight,
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 20,
                right: 20,
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Get.toNamed('/profile');
                      },
                      child: const CircleAvatar(
                        radius: 20,
                        backgroundImage:
                        AssetImage('assets/images/profile_img_test.png'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "bus_rapport".tr,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                left: 10,
                right: 10,
                top: 100,
                child: CustomPaint(
                  size: Size(constraints.maxWidth, constraints.maxHeight),
                  painter: RPSCustomPBusainter(),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10.0, vertical: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "reference".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  reference,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                            ClipRect(
                              child: Image.asset(
                                'assets/images/line_img.png',
                                fit: BoxFit.cover,
                                width: 120,
                              ),
                            ),
                            Column(
                              children: [
                                Text(
                                  "date".tr,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  formattedDate,
                                  style: Theme.of(context)
                                      .textTheme
                                      .displaySmall
                                      ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        const SizedBox(height: 20),
                        Obx(() {
                          return DropdownOptionWidget(
                            controller: controller,
                            options: controller.lineOptions
                                .map((line) => "${line['name']} - ${line['arrival_name']}")
                                .toList(),
                            selectedValue: controller.selectedLineOption,
                            label: "line".tr,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                var selectedLine = controller.lineOptions.firstWhere(
                                      (line) => "${line['name']} - ${line['arrival_name']}" == newValue,
                                );
                                controller.selectedLineOption.value = newValue;
                                print("Selected Line ID: ${selectedLine['id']}");
                              }
                            },
                          );
                        }),


                        const SizedBox(height: 10),

                        Obx(() {
                          return DropdownOptionWidget(
                            controller: controller,
                            options: controller.driverOptions.map((driver) => driver['name'] as String).toList(),
                            selectedValue: controller.selectedDriver,
                            label: "driver".tr,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedDriver.value = newValue;
                              }
                            },
                          );
                        }),

                        const SizedBox(height: 10),

                        Obx(() {
                          return DropdownOptionWidget(
                            controller: controller,
                            options: controller.recipientOptions.map((recipient) => recipient['name'] as String).toList(),
                            selectedValue: controller.selectedRecipient,
                            label: "receiver".tr,
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                controller.selectedRecipient.value = newValue;
                              }
                            },
                          );
                        }),

                        const SizedBox(height: 20),
                        const Padding(
                          padding: EdgeInsets.only(left: 10, right: 10),
                          child: DashedLine(
                            direction: Axis.horizontal,
                            dashLength: 10,
                            dashGap: 3,
                            thickness: 0.5,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Container(
                            width: screenWidth,
                            height: 150,
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: TextField(
                              controller: controller.observationController,
                              decoration: InputDecoration(
                                hintText: "write_your_observation".tr,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 2.0,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(40),
                                  borderSide: BorderSide(
                                    color: Colors.grey.shade200,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),


                        const SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                          ),
                          child: Text(
                            "degree".tr,
                            style: Theme.of(context)
                                .textTheme
                                .displaySmall
                                ?.copyWith(
                              fontWeight: FontWeight.w500,
                              fontSize: 16,
                              // Adjust font size as needed
                              color: Colors.black, // Adjust color if needed
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        Obx(() {
                          return HorizontalRadioList(
                            options: [ "working".tr,
                              "offline".tr,
                              "need_maintenance".tr,
                              ],
                            selectedOption: controller.selectedOption.value,
                            onSelectionChanged: (value) {
                              controller.updateSelectedOption(value);
                            },
                          );
                        }),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 50),
                              child: ElevatedButton(
                                onPressed: () {
                                  // Show confirmation dialog
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return Dialog(
                                        backgroundColor: Colors.transparent,
                                        child: Container(
                                          height: 200,
                                          padding: const EdgeInsets.all(16),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(20),
                                          ),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "are_you_sure_to_save".tr,
                                                textAlign: TextAlign.center,
                                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 18,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Row(
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  ElevatedButton(
                                                    onPressed: () async {
                                                      try {
                                                        print("Saving bus report...");
                                                        await controller.printSelectedValues(busId, context);

                                                        if (controller.success) {
                                                          print("Bus report saved successfully");
                                                          // Delay navigation to ensure UI update
                                                          Future.delayed(Duration(milliseconds: 300), () {
                                                            Navigator.of(context).pop();
                                                            Get.offNamed('/scanQR');
                                                          });
                                                        } else {
                                                          print("Failed to save bus report");
                                                          ScaffoldMessenger.of(context).showSnackBar(
                                                            SnackBar(content: Text("Failed to save bus report".tr)),
                                                          );
                                                        }
                                                      } catch (e) {
                                                        print("Error: $e");
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                          SnackBar(content: Text("An error occurred".tr)),
                                                        );
                                                      }
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: AppColors.primary,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                    child: Text("save".tr, style: TextStyle(color: Colors.white)),
                                                  ),

                                                  SizedBox(width: 10),
                                                  ElevatedButton(
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.grey,
                                                      shape: RoundedRectangleBorder(
                                                        borderRadius: BorderRadius.circular(20),
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "cancel".tr,
                                                      style: TextStyle(color: Colors.white),
                                                    ),
                                                  ),
                                                ],
                                              ),

                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.primary,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                child: Text("confirm".tr, style: TextStyle(color: Colors.white)),
                              ),
                            )
                          ],
                        )


                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
