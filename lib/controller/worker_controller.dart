import 'package:idc_etus_bechar/models/user.dart';
import 'package:idc_etus_bechar/services/api_services_admin.dart';
import 'package:get/get.dart';
import 'package:collection/collection.dart';

class WorkerController extends GetxController {
  final ApiServicesAdmin workerService = ApiServicesAdmin();

  var employees = <User>[].obs;
  var roles = <String>[].obs;
  var isLoading = false.obs;
  var selectedRole = ''.obs;
  var totalEmployeeCount = 0.obs;

  late Future<Map<String, dynamic>> roleData;

  @override
  void onInit() {
    super.onInit();
    fetchRoles();
    fetchEmployees();
    roleData = fetchEmployeesByRoleCounts();
  }

  Future<void> fetchRoles() async {
    try {
      isLoading.value = true;
      roles.value = await workerService.fetchRoles();
    } catch (e) {
      print('Error fetching roles: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployeesByRole(String role) async {
    try {
      isLoading.value = true;
      print('Fetching employees for role: $role');

      selectedRole.value = role;
      List<Map<String, dynamic>> fetchedData = await workerService.getEmployeesByRole(role);

      print('Number of employees fetched for role "$role": ${fetchedData.length}');

      employees.value = fetchedData.map((data) => User.fromJson(data)).toList();
    } catch (e) {
      print('Error fetching employees for role "$role": $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchEmployees() async {
    try {
      isLoading(true);
      final employees = await workerService.fetchEmployees();
      print('Fetched employees: ${employees.length}');
      totalEmployeeCount.value = employees.length;
    } catch (e) {
      print("Error fetching employee data: $e");
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> fetchEmployeesByRoleCounts() async {
    try {
      List<User> employees = await workerService.fetchEmployees();
      var groupedByRole = groupBy(employees, (User employee) => employee.role);
      Map<String, int> roleCounts = groupedByRole.map((role, employees) {
        return MapEntry(role, employees.length);
      });
      Map<String, String> roleImages = {
        'admin': 'assets/images/admin.jpg',
        'controller': 'assets/images/controller_pic.jpg',
        'driver': 'assets/images/driver_img.jpg',
        'receiver': 'assets/images/recipient_img.jpg',
        'accountant': 'assets/images/accountant_pic.jpg',
        'consultant': 'assets/images/driver_img.jpg',
        'intervener': 'assets/images/intervener.jpg',
      };
      Map<String, dynamic> roleDataWithImages = {};
      roleCounts.forEach((role, count) {
        roleDataWithImages[role] = {
          'count': count,
          'imageUrl': roleImages[role] ?? 'assets/images/default.jpg',
        };
      });

      roleDataWithImages.forEach((role, data) {
        print('Role: $role, Count: ${data['count']}, Image: ${data['imageUrl']}');
      });

      return roleDataWithImages;
    } catch (e) {
      print('Error fetching employee role counts: $e');
      throw Exception('Failed to fetch employee role counts');
    }
  }
}
