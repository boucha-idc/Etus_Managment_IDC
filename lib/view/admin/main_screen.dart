import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:idc_etus_bechar/controller/bus_controller.dart';
import 'package:idc_etus_bechar/controller/worker_controller.dart';
import 'package:idc_etus_bechar/models/circle_item.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';
import 'package:idc_etus_bechar/widgets/circle_with_label.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:idc_etus_bechar/widgets/dashes_line.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/widgets/worker_card.dart';

import '../../utils/app_colors.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final BusController busController = Get.put(BusController(apiService: ApiServiceController(),
      apiAdminService:ApiServicesAdmin()));
  final WorkerController workercontroller = Get.put(WorkerController());
  final List<CircleItem> circleItems = [
    CircleItem(
      imagePath: 'assets/status_bus/walk_bus_test.svg',
      label: 'walk',
    ),
    CircleItem(
      imagePath: 'assets/status_bus/reserved_bus_test.svg',
      label: 'Reserved',
    ),
    CircleItem(
      imagePath: 'assets/status_bus/repair_bus_test.svg',
      label: 'Repair',
    ),
    CircleItem(
      imagePath: 'assets/status_bus/offline_bus_test.svg',
      label: 'Offline',
    ),

  ];
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color(0xFFEEF2F5),
     body:  SizedBox(
     height:screenHeight,
     child :Stack(
       children: [
       Positioned(
           top: 0,
           left: 0,
           right: 0,
          child:Container(
           width:screenWidth ,
           height:340,
           decoration:const  BoxDecoration(
             image: DecorationImage(
               image:AssetImage('assets/images/bus_img.png'),
               fit: BoxFit.cover
             )
             ),
            child: Column(
              children:[
                Padding(
                  padding: const EdgeInsets.only(top:40,left:20,right:20),
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
                                color:const Color(0xffFFFFFF),
                                width: 0.8,
                              ),

                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.white,
                              size: 22, // Adjust icon size
                            ),

                          ),
                          const SizedBox(width: 5,),
                          InkWell(
                            onTap: () {
                              Get.toNamed('/account', arguments: "admin");
                            },
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                  color: Colors.transparent,
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                    color:const Color(0xffFFFFFF),// Stroke color
                                    width: 0.8, // Stroke width
                                  ),
                                  image:const  DecorationImage(
                                    image: AssetImage('assets/images/profile_img_test.png'),
                                    fit: BoxFit.cover,
                                  )
                              ),

                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: Text(
                          'Etus Bechar',
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
                )
              ]
            ),

         )),
         Positioned(
           left: 25,
           right: 25,
           top: 140,
           child: Container(
             decoration: BoxDecoration(
               borderRadius: BorderRadius.circular(20),
             ),
             child: Stack(
               children: [
                 // SVG Background
                 ClipRRect(
                   borderRadius: BorderRadius.circular(20),
                   child: SvgPicture.asset(
                     'assets/images/card_work.svg',
                   ),
                 ),

                 Padding(
                   padding: const EdgeInsets.only(top: 20),
                   child: Container(
                     height: 200,
                     decoration: const BoxDecoration(
                       image: DecorationImage(
                         image: AssetImage('assets/images/map.png'),
                         fit: BoxFit.fitWidth,
                       ),
                     ),
                     child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                       crossAxisAlignment: CrossAxisAlignment.center,
                       children: [
                         Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Obx(() => Text(
                               workercontroller.totalEmployeeCount.value.toString(),
                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 22,
                                 color: Colors.black,
                               ),
                               textAlign: TextAlign.center,
                             )),
                             Text(
                               'worker',
                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 16,
                                 color: Colors.black,
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ],
                         ),
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
                         Column(
                           mainAxisAlignment: MainAxisAlignment.center,
                           children: [
                             Obx(() => Text(
                               busController.totalBusCount.value.toString(),
                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 22,
                                 color: Colors.black,
                               ),
                               textAlign: TextAlign.center,
                             )),

                             Text(
                               'Bus',
                               style: Theme.of(context).textTheme.displaySmall?.copyWith(
                                 fontWeight: FontWeight.w600,
                                 fontSize: 16,
                                 color: Colors.black,
                               ),
                               textAlign: TextAlign.center,
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                 ),
                 Positioned(
                   top: 160,
                   left: 20,
                   right: 20,
                   child: SizedBox(
                     height: 90,
                     child: ListView.builder(
                       scrollDirection: Axis.horizontal,
                       itemCount: circleItems.length,
                       itemBuilder: (context, index) {
                         final item = circleItems[index];
                         return Padding(
                           padding: const EdgeInsets.only(right: 16),
                           child: CircleWithLabel(item: item),
                         );
                       },
                     ),
                   ),
                 ),

                 // WorkerCard ListView
                 Positioned(
                   top: 290,
                   left: 10,
                   right: 10,
                   child: SizedBox(
                     height: 210,
                     child: FutureBuilder<Map<String, dynamic>>(
                       future: workercontroller.roleData, // Fetches the data
                       builder: (context, snapshot) {
                         if (snapshot.connectionState == ConnectionState.waiting) {
                           return const Center(child: SpinKitCircle(color: AppColors.primary, size: 25.0));
                         } else if (snapshot.hasError) {
                           return Center(child: Text('Error: ${snapshot.error}'));
                         } else if (snapshot.hasData) {
                           // Using the data to create the worker cards dynamically
                           var workers = snapshot.data!;
                           return ListView.builder(
                             scrollDirection: Axis.horizontal,
                             itemCount: workers.length,
                             itemBuilder: (context, index) {
                               String role = workers.keys.elementAt(index);
                               var worker = workers[role];
                               return Padding(
                                 padding: const EdgeInsets.only(right: 16),
                                 child: WorkerCard(
                                   workName: role,
                                   imageUrl: worker['imageUrl'],
                                   numberWorker: worker['count'].toString(),
                                 ),
                               );
                             },
                           );
                         }
                         return Container();
                       },
                     ),
                   ),
                 ),
               ],
             ),
           ),
         ),
       ],
     ),
          ),
    );
  }
}
