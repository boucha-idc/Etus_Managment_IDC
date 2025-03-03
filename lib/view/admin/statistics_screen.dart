import 'dart:ui';

import 'package:idc_etus_bechar/controller/statistics_controller.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/chart_overlay_demo.dart';
import 'package:idc_etus_bechar/widgets/custom_paint_statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:idc_etus_bechar/models/bus.dart';
import 'package:fl_chart/fl_chart.dart';
class StatisticsScreen extends StatefulWidget {
  @override
  _StatisticsScreenState createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  int selectedTabIndex = 0;
  final busId = Get.arguments.toString();
  String enteringDate = '';
  int nextOilChangeInKm = 0;
  String nextOilChangeDate = '';
  String status="";
  String plate_num="";
  late int id;
  String selectedPeriod = 'Last Month';
  late StatisticsController statisticsController;

  @override
  void initState() {
    super.initState();
    statisticsController = Get.put(StatisticsController());
    _fetchBusDetails();
  }

  Future<void> _fetchBusDetails() async {
    try {
      final statisticsController = StatisticsController();
      final busDetails = await statisticsController.getBusDetailsById(busId);
      setState(() {
        enteringDate = busDetails['entering_date'] ?? '';
        nextOilChangeInKm = busDetails['next_oil_change_in_km'] ?? 0;
        nextOilChangeDate = busDetails['next_oil_change_date'] ?? '';
        status= busDetails['status'] ?? '';
        plate_num= busDetails['plate_number'] ?? '';
        id=busDetails['id']??0;
      });
    } catch (e) {
      // Handle error appropriately (e.g., show a toast or error message)
      print('Error fetching bus details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F5),
      body: SizedBox(
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
                      GestureDetector(
                        onTap: () {
                          Get.toNamed('/HomePage');
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xffCFCFCF),
                              width: 0.8,
                            ),
                          ),
                          child: const Icon(
                            Ionicons.chevron_back_outline,
                            color: Colors.black,
                            size: 22,
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      GestureDetector(
                        onTap: (){
                          Get.toNamed('/account', arguments: "admin");
                        },
                        child:  Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xffCFCFCF),
                              width: 0.8,
                            ),
                            image: const DecorationImage(
                              image: AssetImage('assets/images/profile_img_test.png'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    'Bus Statistics',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black,
                    ),
                  ),
                  GestureDetector(
                    onTap: (){

                      Get.toNamed('/RecipesScreen',arguments: busId);
                      //recipeData
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: const Color(0xffCFCFCF),
                          width: 0.8,
                        ),
                      ),
                      child: const Center(
                        child: Icon(
                          Ionicons.receipt_outline,
                          color: Colors.black,
                          size: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 110,
              child: Container(
                width: screenWidth * 0.9,
                height: screenHeight * 0.36,
                child: CustomPaint(
                  painter: StatisticsCustomPainter(),
                  child:  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: Text(
                              "N°${plate_num}", // Use fallback value
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
                          ),
                          Spacer(),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: SizedBox(
                              width: 130,
                              height: 38,
                              child: PopupMenuButton<String>(
                                color: Colors.transparent,
                                elevation: 0,
                                onSelected: (String value) {
                                  setState(() {
                                    selectedPeriod = value;
                                  });
                                },
                                itemBuilder: (BuildContext context) {
                                  final options = ['Last Month', 'Last 3 Months', 'Last 6 Months'];
                                  return options.map((option) {
                                    return PopupMenuItem<String>(
                                      value: option,
                                      // Wrap each item in a blurred container
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                          child: Container(
                                            width: double.infinity,
                                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                            decoration: BoxDecoration(
                                              color: Colors.white.withOpacity(0.2),
                                              borderRadius: BorderRadius.circular(12),
                                            ),
                                            child: Text(
                                              option,
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList();
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(30),
                                  child: BackdropFilter(
                                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withOpacity(0.5),
                                        borderRadius: BorderRadius.circular(30),
                                        border: Border.all(color: AppColors.primary),
                                      ),
                                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                      alignment: Alignment.center,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            selectedPeriod,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const SizedBox(width: 5),
                                          const Icon(
                                            Icons.arrow_drop_down,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),


                        ],
                      ),
                  SizedBox(height: 10,),
                      Expanded(child: BusStatusGraph())
                 ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 410,
              child: Container(
                width: screenWidth * 0.9,
                height: 90,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [const Color(0xff608BC1), const Color(0xffD9D9D9).withOpacity(0.65)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomLeft,
                  ),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Next Drainage',
                        style: Theme.of(context).textTheme.displayLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.start,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            '100000',
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                          ClipRect(
                            child: Image.asset('assets/images/line_img.png',
                              fit: BoxFit.cover,
                              width: 100,
                            ),
                          ),
                          Text(
                            enteringDate,
                            style: Theme.of(context).textTheme.displaySmall?.copyWith(
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 20,
              right: 20,
              top: 510,
              bottom: 5,
              child: Container(
                width: screenWidth * 0.9,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: screenWidth,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xff133E87).withOpacity(0.42),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          itemCount: 2,
                          itemBuilder: (context, index) {
                            return _buildTab(
                              label: ['Oil', 'Components'][index],
                              isSelected: selectedTabIndex == index,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (selectedTabIndex == 0) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Column(
                              children: [
                                Text("Next change (km): ", style: TextStyle(fontSize: 14)),
                                Text("$nextOilChangeInKm", style: TextStyle(fontSize: 12)),
                              ],
                            ),
                            Column(
                              children: [
                                Text("Next change (Date): ", style: TextStyle(fontSize: 14)),
                                Text(nextOilChangeDate, style: TextStyle(fontSize: 12)),
                              ],
                            )
                          ],
                        ),

                      ] else ...[
                        Obx(() {
                          if (statisticsController.isLoading.value) {
                            return const Center(child: CircularProgressIndicator());
                          }

                          if (statisticsController.types.isEmpty) {
                            return const Center(child: Text("No components available"));
                          }

                          return ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: statisticsController.types.length,
                            itemBuilder: (context, index) {
                              final type = statisticsController.types[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: ListTile(
                                  title: Text(type.name),
                                ),
                              );
                            },
                          );
                        }),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab({
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTabIndex = label == 'Oil' ? 0 : 1;
        });
      },
      child: Container(
        height: 30,
        width: 120,
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
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
}
