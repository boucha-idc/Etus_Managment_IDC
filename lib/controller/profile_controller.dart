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

      // Check if profileData.image is null or empty
      if (profileData.image != null && profileData.image!.isNotEmpty) {
        if (profileData.image!.startsWith('http')) {
          image.value = Uri.decodeFull(profileData.image!);
        } else {
          // Log an issue if the URL is invalid
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

      // Get the controller's ID and role from SharedPreferences
      var tokenData = await getTokenAndUserId();
      int controllerId = tokenData['user_id'];
      String role = tokenData['role_user'];

      // Fetch all reports from the API (returns List<Map<String, dynamic>>?)
      var fetchedReports = await _userService.getAllControllerReports();

      // Log the raw data for debugging purposes
      print("Fetched Reports: $fetchedReports");

      if (fetchedReports != null) {
        // No need to check 'data' as the response is directly a List<Map<String, dynamic>>
        print("Reports Data Before Filtering: $fetchedReports");

        // Directly assign fetchedReports to reportsList
        var reportsList = fetchedReports;

        // Filter reports based on the controller's ID and role
        var filteredReports = reportsList.where((report) {
          int reportControllerId = int.tryParse(report['controller_id'].toString()) ?? 0;
          return reportControllerId == controllerId &&
              report['controller'] != null &&
              report['controller']['role'] == 'controller';
        }).toList();

        // Log the filtered reports
        print("Filtered Reports: $filteredReports");

        if (filteredReports.isNotEmpty) {
          // Calculate counts of reports and buses
          calculateReportCount(filteredReports);
          calculateBusCount(filteredReports);

          List<Map<String, dynamic>> reportsWithDetails = filteredReports.map((report) {
            return {
              'report_id': report['id'],
              'bus_name': report['bus'] != null ? report['bus']['name'] : 'Unknown',  // Null check for bus
              'bus_plate_number': report['bus'] != null ? report['bus']['plate_number'] : 'Unknown',  // Null check for bus plate number
              'line_name': report['line'] != null ? report['line']['name'] : 'Unknown',  // Null check for line
              'driver_name': report['driver'] != null ? report['driver']['name'] : 'Unknown',  // Null check for driver
              'receiver_name': report['receiver'] != null ? report['receiver']['name'] : 'Unknown',  // Null check for receiver
              'bus_status': report['bus_status'] ?? 'Unknown',  // Null check for bus status
              'driver_status': report['driver_status'] ?? 'Unknown',  // Null check for driver status
              'receiver_status': report['receiver_status'] ?? 'Unknown',  // Null check for receiver status
              'road_status': report['road_status'] ?? 'Unknown',  // Null check for road status
            };
          }).toList();

          // Assign the filtered and mapped reports to the observable list
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
      isReportsLoading.value = false;  // Set loading to false once the reports are fetched
    }
  }

  void calculateReportCount(List<dynamic> filteredReports) {
    int reportCountValue = filteredReports.length;
    print("Count of Reports: $reportCountValue");

    // Update the observable
    reportCount.value = reportCountValue;
  }

  // Calculate the bus count
  void calculateBusCount(List<dynamic> filteredReports) {
    Set<int> controlledBuses = {};  // Use a Set to count unique bus IDs

    for (var report in filteredReports) {
      controlledBuses.add(report['bus_id']);
    }

    int busCountValue = controlledBuses.length;
    print("Count of Buses Controlled: $busCountValue");

    // Update the observable
    busCount.value = busCountValue;
  }

  // Logout method
  Future<void> logout() async {
    try {
      // Clear user data from SharedPreferences or state management
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();  // Clear all stored preferences
      Get.offAllNamed('/signIn'); // Replace '/login' with your login route

      // Show a success message
      Get.snackbar(
        "Success",
        "You have been logged out.",
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      // Handle any errors during logout
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
