import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/models/circle_item.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/widgets/circle_with_label.dart';
import 'package:idc_etus_bechar/widgets/details_card.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:idc_etus_bechar/utils/app_colors.dart';
class BusSituation extends StatefulWidget {
  const BusSituation({super.key});

  @override
  State<BusSituation> createState() => _BusSituationState();
}

class _BusSituationState extends State<BusSituation> {
  int currentIndex = 0;
  final ApiServicesAdmin _apiServicesAdmin = ApiServicesAdmin();
  late Future<Map<String, List<Bus>>> buses;

  final List<CircleItem> circleItems = [
    CircleItem(imagePath: 'assets/status_bus/walk_bus_test.svg', label: 'Bus Active'),
    CircleItem(imagePath: 'assets/status_bus/reserved_bus_test.svg', label: 'Bus Reserved'),
    CircleItem(imagePath: 'assets/status_bus/repair_bus_test.svg', label: 'Bus Repair'),
    CircleItem(imagePath: 'assets/status_bus/offline_bus_test.svg', label: 'Bus Offline'),
  ];

  @override
  void initState() {
    super.initState();
    buses = _apiServicesAdmin.fetchBusData();
  }

  void showPreviousItem() {
    setState(() {
      currentIndex = (currentIndex - 1 + circleItems.length) % circleItems.length;
    });
  }

  void showNextItem() {
    setState(() {
      currentIndex = (currentIndex + 1) % circleItems.length;
    });
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
              child: Container(
                width: screenWidth,
                height: 270,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/images/bus_status.png'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Stack(
                  alignment: Alignment.center,
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
                              Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color: Color(0xffCFCFCF),
                                    width: 0.8,
                                  ),
                                ),
                                child: Icon(
                                  Icons.notifications,
                                  color: Colors.black,
                                  size: 22,
                                ),
                              ),
                              SizedBox(width: 5),
                              GestureDetector(
                                onTap: (){
                                  Get.toNamed('/account', arguments: "admin");
                                },
                                child:  Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: Color(0xffCFCFCF),
                                      width: 0.8,
                                    ),
                                    image: DecorationImage(
                                      image: AssetImage('assets/images/profile_img_test.png'),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Expanded(
                            child: Text(
                              'Bus Status',
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
                    Positioned(
                      left: 20,
                      right: 20,
                      top: 120,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            children: [
                              FutureBuilder<Map<String, List<Bus>>>(
                                future: buses,  // Use the 'buses' variable here
                                builder: (context, snapshot) {
                                  // Check the connection state
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: SpinKitCircle(color: AppColors.primary, size: 25.0));
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No data available.'));
                                  }
                                  var busData = snapshot.data!;
                                  int totalBuses = busData['active']!.length
                                   + busData['repair']!.length + busData['reserved']!.length
                                    + busData['offline']!.length;

                                  return Column(
                                    children: [
                                      Text(
                                        '$totalBuses',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 20,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Total Bus',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.start,
                                      ),
                                    ],
                                  );
                                },
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
                              FutureBuilder<Map<String, List<Bus>>>(
                                future: buses,
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return Center(child: SpinKitCircle(color: AppColors.primary, size: 25.0));
                                  } else if (snapshot.hasError) {
                                    return Center(child: Text('Error: ${snapshot.error}'));
                                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                                    return Center(child: Text('No data available.'));
                                  }
                                  var busData = snapshot.data!;
                                  int totalBuses = busData['active']?.length ?? 0 ;
                                  return Column(
                                    children: [
                                      Text(
                                        '$totalBuses',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 24,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Walk-Bus',
                                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.end,
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                       ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: showPreviousItem,
                            child: Icon(
                              Icons.arrow_left,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                          SizedBox(width: 120),
                          GestureDetector(
                            onTap: showNextItem,
                            child: Icon(
                              Icons.arrow_right,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 220,
              left: 20,
              right: 20,
              child: Center(
                child: CircleWithLabel(item: circleItems[currentIndex]),
              ),
            ),
            Positioned(
              top: 310,
              left: 15,
              right: 15,
              child: FutureBuilder<Map<String, List<Bus>>>(
                future: buses,  // Use the 'buses' variable here
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: SpinKitCircle(color: AppColors.primary, size: 25.0));
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No data available.'));
                  }

                  var busData = snapshot.data!;
                  String selectedCategory;
                  if (circleItems[currentIndex].label == 'Bus Active') {
                    selectedCategory = 'active';
                  } else if (circleItems[currentIndex].label == 'Bus Reserved') {
                    selectedCategory = 'offline_reserved';
                  } else if (circleItems[currentIndex].label == 'Bus Repair') {
                    selectedCategory = 'repair';
                  } else {
                    selectedCategory = '';
                  }

                  var busesInCategory = busData[selectedCategory] ?? [];

                  if (busesInCategory.isEmpty) {
                    return Center(child: Text('No buses available for this status.'));
                  }

                  return SizedBox(
                    height: 385,
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                      itemCount: busesInCategory.length,
                      itemBuilder: (context, index) {
                        var bus = busesInCategory[index];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 15.0),
                          child: SizedBox(
                            height: 125,
                            child: DetailsCard(
                              profileImage: 'assets/images/bus_img.png',
                              firstText: bus.name ?? 'Unknown Plate',
                              secondText: bus.plateNumber ?? 'Unknown Line',
                              icon: Icons.stacked_bar_chart,
                              onTap: () {
                                Get.toNamed('/busStatics', arguments: bus.id);
                              },
                            ),
                          ),
                        );
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

