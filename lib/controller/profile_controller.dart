import 'package:idc_etus_bechar/models/user.dart';
import 'package:idc_etus_bechar/services/api_services_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileController extends GetxController {
  var userName = ''.obs;
  var userEmail = ''.obs;
  var userRole = ''.obs;
  var image=''.obs;
  var isLoading = true.obs;
  var controllerReports = <Map<String, dynamic>>[].obs;
  var isReportsLoading = true.obs;
  var errorMessage = ''.obs;
  var reportCount = 0.obs;
  var busCount = 0.obs;
  final ApiServiceController _userService = ApiServiceController();

  @override
  void onInit() {
    super.onInit();
    fetchUserProfile();
    fetchControllerReports();
  }

  Future<void> fetchUserProfile() async {
    try {
      isLoading.value = true;
      User profileData = await _userService.fetchUserProfile();

      print("Profile Data: $profileData");
      print("Image URL: ${profileData.image}");
      if (profileData.image != null && profileData.image!.isNotEmpty) {
        if (profileData.image!.startsWith('http')) {
          image.value = Uri.decodeFull(profileData.image!);
        } else {
          print("⚠ Invalid image URL: ${profileData.image}");
          image.value = 'assets/images/profile_img_test.png';
        }
      } else {
        image.value = 'assets/images/profile_img_test.png';
      }

      userName.value = profileData.name ?? 'Unknown User';
      userEmail.value = profileData.email ?? 'No Email Provided';
      userRole.value = profileData.role ?? 'No Role';

      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      print("Error: $e");
    }
  }

  Future<void> fetchControllerReports() async {
    try {
      isReportsLoading.value = true;
      var tokenData = await getTokenAndUserId();
      int controllerId = tokenData['user_id'];
      String role = tokenData['role_user'];
      var fetchedReports = await _userService.getAllControllerReports();
      print("Fetched Reports: $fetchedReports");

      if (fetchedReports != null) {
        print("Reports Data Before Filtering: $fetchedReports");
        var reportsList = fetchedReports;
        var filteredReports = reportsList.where((report) {
          int reportControllerId = int.tryParse(report['controller_id'].toString()) ?? 0;
          return reportControllerId == controllerId &&
              report['controller'] != null &&
              report['controller']['role'] == 'controller';
        }).toList();
        print("Filtered Reports: $filteredReports");

        if (filteredReports.isNotEmpty) {
          calculateReportCount(filteredReports);
          calculateBusCount(filteredReports);

          List<Map<String, dynamic>> reportsWithDetails = filteredReports.map((report) {
            return {
              'report_id': report['id'],
              'bus_name': report['bus'] != null ? report['bus']['name'] : 'Unknown',
              'bus_plate_number': report['bus'] != null ? report['bus']['plate_number'] : 'Unknown',
              'line_name': report['line'] != null ? report['line']['name'] : 'Unknown',
              'driver_name': report['driver'] != null ? report['driver']['name'] : 'Unknown',
              'receiver_name': report['receiver'] != null ? report['receiver']['name'] : 'Unknown',
              'bus_status': report['bus_status'] ?? 'Unknown',
              'driver_status': report['driver_status'] ?? 'Unknown',
              'receiver_status': report['receiver_status'] ?? 'Unknown',
              'road_status': report['road_status'] ?? 'Unknown',
            };
          }).toList();

          controllerReports.assignAll(reportsWithDetails);
        } else {
          errorMessage.value = "No reports found for this controller.";
        }
      } else {
        errorMessage.value = "Failed to fetch reports or no reports available.";
      }
    } catch (e) {
      errorMessage.value = 'Error fetching controller reports: $e';
      print("Error fetching reports: $e");
    } finally {
      isReportsLoading.value = false;
    }
  }

  void calculateReportCount(List<dynamic> filteredReports) {
    int reportCountValue = filteredReports.length;
    print("Count of Reports: $reportCountValue");

    reportCount.value = reportCountValue;
  }

  // Calculate the bus count
  void calculateBusCount(List<dynamic> filteredReports) {
    Set<int> controlledBuses = {};

    for (var report in filteredReports) {
      controlledBuses.add(report['bus_id']);
    }

    int busCountValue = controlledBuses.length;
    print("Count of Buses Controlled: $busCountValue");

    busCount.value = busCountValue;
  }

  // Logout method
  Future<void> logout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
      Get.offAllNamed('/signIn');
      Get.snackbar(
        "Success",
        "You have been logged out.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      print("Logout error: $e");
      Get.snackbar(
        "Error",
        "Failed to log out. Please try again.",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  Future<Map<String, dynamic>> getTokenAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int controllerId = prefs.getInt('user_id') ?? 0;
    String role = prefs.getString('role') ?? '';
    return {
      'user_id': controllerId,
      'role_user': role,
    };
  }
}
