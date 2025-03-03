import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';
import 'package:get/get.dart';

class BusController extends GetxController {
  var isLoading = false.obs;
  var bus = Bus().obs;
  var totalBusCount = 0.obs;
  var errorMessage = ''.obs;
  var buses = <Bus>[].obs;

  final ApiServiceController apiService;
  final ApiServicesAdmin apiAdminService;

  BusController({required this.apiService, required this.apiAdminService});

  @override
  void onInit() {
    super.onInit();
    fetchBusData();
  }

  Future<Map<String, dynamic>?> verifyReference(String reference) async {
    isLoading(true);
    try {
      var response = await apiService.getBusByReference(reference);
      if (response != null && response['qr_code'] == reference) {
        bus.value = Bus.fromJson(response);
        return {'reference': reference, 'busId': bus.value.id};
      } else {
        print("Invalid reference or no matching bus found.");
      }
    } catch (e) {
      print("Error verifying reference: $e");
    } finally {
      isLoading(false);
    }
    return null;
  }

  Future<void> fetchBusData() async {
    try {
      isLoading(true);
      final data = await apiAdminService.fetchBusData();

      if (data != null) {
        int total = data['active']!.length +
            data['repair']!.length +
            data['reserved']!.length +
            data['offline']!.length;

        totalBusCount.value = total;
        errorMessage.value = '';
      } else {
        errorMessage.value = 'No data found';
        totalBusCount.value = 0;
      }
    } catch (e) {
      errorMessage.value = 'Error fetching bus data: $e';
      totalBusCount.value = 0;
    } finally {
      isLoading(false);
    }
  }

}
