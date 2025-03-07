import 'dart:ui';

import 'package:idc_etus_bechar/controller/recipes_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/custom_bus_painter.dart';
import 'package:idc_etus_bechar/widgets/custom_recipes_count.dart';
import 'package:idc_etus_bechar/widgets/custom_recipes_data.dart';
import 'package:idc_etus_bechar/widgets/date_picker_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RecipeScreen extends StatefulWidget {
  @override
  _RecipeScreenState createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  final Rx<DateTime?> selectedStartDate = Rx<DateTime?>(null);
  final Rx<DateTime?> selectedEndDate = Rx<DateTime?>(null);
  final busId = int.tryParse(Get.arguments as String? ?? '') ?? 0;
  final BusTripController busTripController = Get.find<BusTripController>();

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, _showDatePickerDialog);
  }

  void _showDatePickerDialog() {
    busTripController.fetchBusTrips(); // Fetch data first

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Stack(
          children: [
            BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
              child: Container(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            Center(
              child: AlertDialog(
                backgroundColor: Colors.white.withOpacity(0.5),
                title: const Text("Select Date Range",),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Obx(() {
                      // Check if busTripController is loading, show spinner if true
                      if (busTripController.isLoading) {
                        return Center(
                          child: SpinKitCircle(
                            color: AppColors.primary,
                            size: 50.0,
                          ),
                        );
                      } else {
                        // If loading is complete, display DatePickerButton
                        return Column(
                          children: [
                            DatePickerButton(
                              title: "Start Date",
                              initialDate: busTripController.selectedStartDate ?? DateTime.now(),
                              onDateChanged: (newDate) {
                                busTripController.selectedStartDate = newDate;
                              },
                            ),
                            const SizedBox(height: 16),
                            DatePickerButton(
                              title: "End Date",
                              initialDate: busTripController.selectedEndDate ?? DateTime.now(),
                              onDateChanged: (newDate) {
                                if (busTripController.selectedEndDate == null ||
                                    newDate.isBefore(busTripController.selectedEndDate!)) {
                                  busTripController.selectedEndDate = newDate;
                                } else {
                                  Get.snackbar(
                                    'Invalid Date',
                                    'Start date must be before ${DateFormat('yyyy-MM-dd').format(busTripController.selectedEndDate!)}.',
                                    snackPosition: SnackPosition.BOTTOM,
                                  );
                                }
                              },
                            ),
                          ],
                        );
                      }
                    }),
                  ],
                ),
                actions: [
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // Ensure selectedStartDate and selectedEndDate are not null
                        if (busTripController.selectedStartDate != null &&
                            busTripController.selectedEndDate != null) {
                          Navigator.pop(context); // Close dialog if dates are valid
                          busTripController.fetchFilteredRecipes(
                            busTripController.selectedStartDate!,
                            busTripController.selectedEndDate!,
                          );
                        } else {
                          Get.snackbar(
                            'Incomplete Selection',
                            'Please select both start and end dates.',
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,

                      ),
                      child: const Text("Confirm", style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          double customPaintHeight = constraints.maxHeight * 0.4;
          return Stack(
            children: [
              _buildBackgroundImage(constraints),
              _buildHeader(constraints),
              _buildCustomPaint(constraints),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBackgroundImage(BoxConstraints constraints) {
    return ClipRect(
      child: Align(
        alignment: Alignment.center,
        child: Image.asset(
          'assets/images/scan_pic.jpg',
          fit: BoxFit.cover,
          width: constraints.maxWidth,
          height: constraints.maxHeight,
        ),
      ),
    );
  }

  Widget _buildHeader(BoxConstraints constraints) {
    return Positioned(
      top: 40,
      left: 10,
      right: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              _buildBackButton(),
              const SizedBox(width: 5),
              _buildProfileAvatar(),
            ],
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Available Recipes',
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
    );
  }

  Widget _buildBackButton() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/busStatics', arguments: 'busId');
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
        ),
        child: const Icon(
          Icons.arrow_back,
          color: Colors.white,
          size: 22,
        ),
      ),
    );
  }

  Widget _buildProfileAvatar() {
    return GestureDetector(
      onTap: () {
        Get.toNamed('/account', arguments: "admin");
      },
      child: const CircleAvatar(
        radius: 15,
        backgroundImage: AssetImage('assets/images/profile_img_test.png'),
      ),
    );
  }

  Widget _buildCustomPaint(BoxConstraints constraints) {
    return Positioned(
      left: 10,
      right: 10,
      top: 100,
      child: CustomPaint(
        size: Size(
          constraints.maxWidth,
          constraints.maxHeight,
        ),
        painter: RPSCustomPBusainter(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDatePickers(),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
                child: Obx(() {
                  List<String> recipeNames = busTripController.filteredRecipes
                      .map((busTrip) => busTrip.busId.toString())
                      .toList();

                  return CustomBusTripsWidget(
                    busTrips: busTripController.filteredRecipes,
                    errorMessage: busTripController.errorMessage,
                    busTripCount: busTripController.filteredRecipes.length,
                    selectedRecipeIndex: busTripController.recipeCount,
                    recipeNames: recipeNames,
                  );
                }),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickers() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Obx(() => IgnorePointer(
            child: DatePickerButton(
              initialDate: busTripController.selectedStartDate ?? DateTime.now(),
              onDateChanged: (newDate) {
                selectedStartDate.value = newDate;
              },
              title: "",
            ),
          )),
          Obx(() => IgnorePointer(
            child: DatePickerButton(
              initialDate: busTripController.selectedEndDate ?? DateTime.now(),
              onDateChanged: (newDate) {
                selectedEndDate.value = newDate;
              },
              title: "",
            ),
          )),
        ],
      ),
    );
  }
}
