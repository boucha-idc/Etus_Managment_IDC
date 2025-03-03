import 'package:get/get.dart';
import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';

import '../models/maintenance.dart';

class StatisticsController {
  var types = <Maintenance>[].obs;
  var isLoading = false.obs;
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
  void fetchTypes() async {
    try {
      isLoading.value = true;
      var fetchedTypes = await StatisticsService.fetchTypes();
      types.assignAll(fetchedTypes);
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
