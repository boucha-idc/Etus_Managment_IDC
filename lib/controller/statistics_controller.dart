import 'package:get/get.dart';
import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';

import '../models/maintenance.dart';

class StatisticsController {
  var types = <Maintenance>[].obs;
  var isLoading = false.obs;
  var busStatistics = <Map<String, dynamic>>[].obs;
  final ApiServicesAdmin StatisticsService = ApiServicesAdmin();

  Future<Map<String, dynamic>> getBusDetailsById(String busId) async {
    final Map<String, List<Bus>> busesMap = await StatisticsService.fetchBusData();

    List<Bus> allBuses = busesMap.values.expand((buses) => buses).toList();

    Bus? bus = allBuses.firstWhere(
          (bus) => bus.id.toString() == busId,
      orElse: () => throw Exception('Bus with ID $busId not found'),
    );

    if (bus != null) {
      return {
        'entering_date': bus.enteringDate,
        'next_oil_change_in_km': bus.nextOilChangeInKm,
        'next_oil_change_date': bus.nextOilChangeDate,
         'plate_number':bus.plateNumber,
        'status':bus.status,
        'id':bus.id

      };
    } else {
      throw Exception('Bus with ID $busId not found');
    }
  }

  void fetchBusStatisticsById(int busId) async {
    try {
      Future.delayed(Duration.zero, () {
        isLoading.value = true;
      });

      var statistics = await StatisticsService.fetchBusComponents(busId);

      Future.delayed(Duration.zero, () {
        busStatistics.assignAll(statistics);
      });
    } catch (e) {
      print("Error fetching bus statistics: $e");
      Get.snackbar("Error", e.toString());
    } finally {
      Future.delayed(Duration.zero, () {
        isLoading.value = false;
      });
    }
  }




}
