import 'package:idc_etus_bechar/utils/app_colors.dart';
import 'package:idc_etus_bechar/widgets/custom_recipes_count.dart';
import 'package:idc_etus_bechar/widgets/dashes_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/models/bus_trip.dart';
import 'package:intl/intl.dart';

class CustomBusTripsWidget extends StatefulWidget {
  final List<BusTrip> busTrips;
  final String errorMessage;
  final int busTripCount;
  final int selectedRecipeIndex;
  final List<String> recipeNames;

  CustomBusTripsWidget({
    required this.busTrips,
    required this.errorMessage,
    required this.busTripCount,
    required this.selectedRecipeIndex,
    required this.recipeNames,
  });

  @override
  State<CustomBusTripsWidget> createState() => _CustomBusTripsWidgetState();
}

class _CustomBusTripsWidgetState extends State<CustomBusTripsWidget> {
  int selectedRecipeIndex = 0;
  bool isLoading = true;
  String formattedDate = DateFormat('dd/MM/yyyy').format(DateTime.now());
  @override
  void initState() {
    super.initState();
    // Simulate loading with a delay
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        isLoading = false; // After 2 seconds, set loading to false
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = '';
    double screenWidth = MediaQuery.of(context).size.width;
    return SingleChildScrollView(
        child: Column(children: [
      if (isLoading)
        Center(
          child: SpinKitCircle(
            color: AppColors.primary,
            size: 50.0,
          ),
        )
      else if (widget.busTrips.isEmpty)
        // Show "No Data" message if no data is available
        Center(
          child: Text(
            'No Data Available',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.black,
                ),
            textAlign: TextAlign.center,
          ),
        )
      else
        Column(
          children: [
            Center(
              child: CustomRecipeCountControl(
                recipeNames: widget.recipeNames,
                busTripCount: widget.busTripCount,
                selectedRecipeIndex: selectedRecipeIndex,
                onCircleTap: (int index) {},
                onSelectedIndexChange: (int newIndex) {
                  setState(() {
                    selectedRecipeIndex = newIndex; // Update selected index
                  });
                },
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.busTrips.length,
              itemBuilder: (context, index) {
                final busTrip = widget.busTrips[index];
                TextEditingController _controller = TextEditingController(text: busTrip.observation);


                if (busTrip.updatedAt != null) {
                  DateTime parsedDate = DateTime.parse(busTrip.updatedAt!);
                  formattedDate = DateFormat('yyyy-MM-dd').format(parsedDate);
                }
                return Padding(
                  padding: const EdgeInsets.only(left: 10,right: 10),
                  child: Column(
                    children: [
                      if (index == selectedRecipeIndex)
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Column(
                                  children: [
                                    Text(
                                      'Reference',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      busTrip.bus.plateNumber,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      busTrip.line.name,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    ClipRect(
                                      child: Image.asset(
                                        'assets/images/line_img.png',
                                        fit: BoxFit.cover,
                                        width: 120,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Create At',
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      formattedDate ,
                                      style: Theme.of(context)
                                          .textTheme
                                          .displaySmall
                                          ?.copyWith(
                                            fontWeight: FontWeight.w400,
                                            fontSize: 10,
                                            color: Colors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Accounts ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.accountant.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Amount ',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.amount.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: DashedLine(
                                direction: Axis.horizontal,
                                dashLength: 10,
                                dashGap: 3,
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 20),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Chauffeur',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.driver.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Receveur',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.receiver.name,
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(left: 10, right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        'Start Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.startDate.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'End Date',
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        busTrip.endDate.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .displaySmall
                                            ?.copyWith(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 10,
                                              color: Colors.black,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, top: 20),
                              child: Container(
                                width: screenWidth,
                                height: 80,
                                decoration: BoxDecoration(
                                  color: Colors.grey.shade200,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: TextField(
                                  controller: _controller,

                                  decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 2.0,
                                      ),
                                    ),
                                    hintText: "Recipes Observation",
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade200,
                                        width: 2.0,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 20,),
                            Center(
                              child: Container(
                                height: 2,
                                width: 200,
                                color: Colors.grey,
                              ),
                            )

                          ],
                        ),


                    ],
                  ),
                );
              },
            ),
          ],
        ),
    ]));
  }
}
