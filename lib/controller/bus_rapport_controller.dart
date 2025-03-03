import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BusRapportController extends GetxController {
  var lineOptions = <Map<String, dynamic>>[].obs;
  var driverOptions = <Map<String, dynamic>>[].obs;
  var recipientOptions = <Map<String, dynamic>>[].obs;
  var selectedDriver = ''.obs;
  var selectedRecipient = ''.obs;
  var selectedLineOption = ''.obs;
  var isLoading = true.obs; // Loading state
  var errorMessage = ''.obs;
  var selectedOption = 'Working'.obs;
  bool success=false;
  TextEditingController observationController = TextEditingController();
  final ApiServiceController _ContrllerService = ApiServiceController();
  final ApiServicesAdmin _driveReceiver = ApiServicesAdmin();

  @override
  void onInit() {
    super.onInit();
    fetchLines();
    fetchEmployees();
  }


  Future<void> fetchLines() async {
    try {
      isLoading(true);
      var lines = await _ContrllerService.fetchLineNames();
      var lineData = lines.map((line) {
        return {
          'id': line['id'],
          'name': line['name'],
          'arrival_name': line['arrival_name'],
        };
      }).toList();

      lineOptions.assignAll(lineData);
      print("Line Names with Arrival: $lineOptions");
    } catch (e) {
      errorMessage.value = 'Error fetching lines: $e';
    } finally {
      isLoading(false);
    }
  }


  Future<void> fetchEmployees() async {
    try {
      isLoading(true);
      var drivers = await _driveReceiver.getEmployeesByRole('driver');
      driverOptions.assignAll(drivers.map((e) => {
        'id': e['id'],
        'name': e['name'].toString()
      }).toList());

      driverOptions.forEach((driver) {
        print("Driver ID: ${driver['id']}, Name: ${driver['name']}");
      });

      var recipients = await _driveReceiver.getEmployeesByRole('receiver');
      recipientOptions.assignAll(recipients.map((e) => {
        'id': e['id'],
        'name': e['name'].toString()
      }).toList());

      recipientOptions.forEach((recipient) {
        print("Recipient ID: ${recipient['id']}, Name: ${recipient['name']}");
      });
    } catch (e) {
      errorMessage.value = 'Error fetching employees: $e';
    } finally {
      isLoading(false);
    }
  }

  void updateSelectedOption(String value) {
    selectedOption.value = value;
  }
  Future<void> printSelectedValues(int bus_id, BuildContext context) async {
    try {
      if (isLoading.value) {
        print("Data is still loading. Please wait.");
        return;
      }

      var selectedLine = lineOptions.firstWhere(
            (line) =>
        "${line['name']} - ${line['arrival_name']}" == selectedLineOption.value,
        orElse: () => {'id': null, 'name': null, 'arrival_name': null},
      );

      print("Selected Line: ${selectedLineOption.value}");
      print("Selected Line ID: ${selectedLine['id']}");

      var selectedDriverData = driverOptions.firstWhere(
            (driver) => driver['name'] == selectedDriver.value,
        orElse: () => {'id': null, 'name': null},
      );
      var selectedRecipientData = recipientOptions.firstWhere(
            (recipient) => recipient['name'] == selectedRecipient.value,
        orElse: () => {'id': null, 'name': null},
      );

      if (selectedLine['id'] == null || selectedDriverData['id'] == null || selectedRecipientData['id'] == null) {
        print("Error: One or more selected values are not found in the lists.");
        Get.snackbar(
          "Error",
          "Please ensure all fields are selected correctly.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      var userData = await getTokenAndUserId();
      int controller_id = userData['user_id'];
      String observationText = observationController.text;

      print("Bus ID: $bus_id");
      print("Controller ID: $controller_id");
      print("Selected Line ID: ${selectedLine['id']}");
      print("Selected Driver ID: ${selectedDriverData['id']}");
      print("Selected Recipient ID: ${selectedRecipientData['id']}");
      print("Observation: $observationText");
      print("Selected Status: ${selectedOption.value}");

      // Proceed only if valid data is available
      if (selectedLine['id'] != null && selectedDriverData['id'] != null && selectedRecipientData['id'] != null) {
        var busData = {
          "bus_id": bus_id,
          "controller_id": controller_id,
          "driver_id": selectedDriverData['id'],
          "receiver_id": selectedRecipientData['id'],
          "line_id": selectedLine['id'],
          "bus_status": selectedOption.value,
          "driver_status": "good",
          "receiver_status": "good",
          "road_status": "good",
        };

        success = await _ContrllerService.saveBusReport(busData);

        if (success) {
          print("Bus report saved successfully.");
          Get.snackbar(
            "Success",
            "Bus report saved successfully.",
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          print("Failed to save bus report.");
          Get.snackbar(
            "Error",
            "Failed to save bus report.",
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print("Error in printSelectedValues: $e");
      Get.snackbar(
        "Error",
        "An error occurred while saving the report.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }




  Future<Map<String, dynamic>> getTokenAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int controller_id = prefs.getInt('user_id') ?? 0;
    return {
      'user_id': controller_id,
    };
  }
}
