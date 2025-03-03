import 'package:idc_etus_bechar/models/bus.dart';
import 'package:idc_etus_bechar/models/bus_trip.dart';
import 'package:idc_etus_bechar/models/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/maintenance.dart' show Maintenance;
class ApiServicesAdmin {
  final String baseUrl="https://idevelopcompany.dz/IDC%20Projects/BusManagement/api";
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }
  Future<Map<String, List<Bus>>> fetchBusData() async {
    final url = Uri.parse('$baseUrl/buses');

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not available.");
      }
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',  // Include the token here
        },
      );

      print('Response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<Bus> buses = [];
        for (var item in data['data']) {
          buses.add(Bus.fromJson(item));
        }
        List<Bus> activeBuses = buses.where((bus) => bus.status == 'walk').toList();
        List<Bus> repairBuses = buses.where((bus) => bus.status == 'repair').toList();
        List<Bus> ReservedBuses = buses.where((bus) => bus.status == 'broken').toList();
        List<Bus> offlineBuses = buses.where((bus) => bus.status == 'reserved').toList();
        return {
          'active': activeBuses,
          'repair': repairBuses,
          'reserved': ReservedBuses,
          'offline': offlineBuses,
        };
      } else {
        throw Exception('Failed to load bus data');
      }
    } catch (e) {
      rethrow;
    }
  }
  Future<List<User>> fetchEmployees() async {
    try {
      final String? token = await getToken();

      if (token == null) {
        throw Exception('Token not found');
      }
      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };
      final response = await http.get(
        Uri.parse('$baseUrl/employees'),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<User> employees = [];
        for (var employeeJson in data['data']) {
          employees.add(User.fromJson(employeeJson));
        }
        return employees;
      } else {
        print('Error: ${response.statusCode}, Body: ${response.body}');
        throw Exception('Failed to load employees');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      throw Exception('Failed to fetch employees');
    }
  }
  Future<List<String>> fetchRoles() async {
    final url = Uri.parse('$baseUrl/employees/roles/read-all');
    final token = await getToken();
    if (token == null) {
      throw Exception("Token is not available.");
    }
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['success'] == true) {
        return List<String>.from(data['data']);
      } else {
        throw Exception('Failed to fetch roles');
      }
    } else {
      throw Exception('Failed to fetch roles');
    }
  }
  Future<List<User>> fetchEmployeesByRole(String role) async {
    final url = Uri.parse('$baseUrl/employees');
    final token = await getToken();

    if (token == null) {
      throw Exception("Token is not available.");
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      final List<dynamic> employeesData = responseData['data'];
      final filteredEmployees = employeesData
          .where((employeeData) => employeeData['role'] == role)
          .map((employeeData) => User.fromJson(employeeData))
          .toList();

      return filteredEmployees;
    } else {
      throw Exception('Failed to fetch employees');
    }
  }
  Future<List<Map<String, dynamic>>> getEmployeesByRole(String role) async {
    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not available.");
      }
      final response = await http.get(
        Uri.parse('$baseUrl/employees/read/all?role=$role'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        print('Response Body: ${response.body}');
        if (responseData['success'] == true && responseData['data'] is List) {
          return List<Map<String, dynamic>>.from(responseData['data']);
        } else {
          throw Exception('Unexpected response format or missing data field');
        }
      } else {
        throw Exception('Failed to fetch employees. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching employees: $e');
      return [];
    }
  }
 /* Future<Map<String, dynamic>> fetchBusStatistics() async {
    final url = Uri.parse('$baseUrl/statistics/operations');
    final token = await getToken();

    if (token == null) {
      throw Exception("Token is not available.");
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['data'];
    } else {
      throw Exception('Failed to fetch bus statistics');
    }
  }*/
  Future<List<BusTrip>> fetchTripBus(int busId) async {
    final url = Uri.parse('$baseUrl/recipes/paginated/dynamic-search');

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not available.");
      }

      final response = await http.get(
        url.replace(queryParameters: {'bus_id': busId.toString()}),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        print('Response data: ${data}');
        if (data['success'] == true) {
          if (data['data'] != null && data['data']['data'] != null) {
            List<dynamic> busTripsData = data['data']['data'];

            if (busTripsData.isNotEmpty) {
              List<BusTrip> busTrips = busTripsData.map((item) => BusTrip.fromJson(item)).toList();
              return busTrips;
            } else {
              throw Exception('No bus trips found in the response data.');
            }
          } else {
            throw Exception('Invalid response format: No bus trips data found.');
          }
        } else {
          throw Exception('No bus trips found or the request was unsuccessful');
        }
      } else {
        throw Exception('Failed to load bus trips. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching bus trips: $e');
      throw Exception('Failed to fetch bus trips: $e');
    }
  }
  Future<List<BusTrip>> fetchFilteredRecipes(String fromDate, String toDate) async {
    final url = Uri.parse('$baseUrl/recipes/filtered/read-all?from_date=$fromDate&to_date=$toDate');
    final token = await getToken();

    if (token == null) {
      throw Exception("Token is not available.");
    }

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      print('Filtered recipes fetched services: $data');
      if (data['success'] == true) {
        return (data['data'] as List<dynamic>)
            .map((item) => BusTrip.fromJson(item as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch filtered recipes: ${data['message']}');
      }
    } else {
      throw Exception('Failed to fetch filtered recipes. Status code: ${response.statusCode}');
    }
  }
  Future<List<Maintenance>> fetchTypes() async {
    try {
      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        if (data["success"] == true) {
          List<Maintenance> types = (data["data"] as List)
              .map((item) => Maintenance.fromJson(item))
              .toList();
          return types;
        } else {
          throw Exception("Failed to fetch types: ${data['message']}");
        }
      } else {
        throw Exception("Failed to load types, Status Code: ${response.statusCode}");
      }
    } catch (e) {
      throw Exception("Error fetching types: $e");
    }
  }

}


