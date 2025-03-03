import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ApiServiceAuth {
  final String baseUrl =
      "https://idevelopcompany.dz/IDC%20Projects/BusManagement/api";

  Future<Map<String, dynamic>?> signIn(String phoneNumber, String password) async {
    String apiUrl = "$baseUrl/employees/authenticate";

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: json.encode({
          "phone_number": phoneNumber,
          "password": password,
        }),
      );

      final result = json.decode(response.body);

      if (response.statusCode == 200 && result['success'] == true) {
        int id = result['employee']['id'] ?? 0;
        await saveUserData(
          id: id,
          token: result['token'],
          name: result['employee']['name'],
          role: result['employee']['role'],
        );
        return result;
      } else {
        print("Error Response: ${response.body}");
        return {"success": false, "message": result['message'] ?? "Unknown error"};
      }
    } catch (e) {
      print("Exception Occurred: $e");
      return {"success": false, "message": "Failed to sign in: $e"};
    }
  }

  Future<void> saveUserData({
    required int id,
    required String token,
    required String name,
    required String role,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', id);
    await prefs.setString('username', name);
    await prefs.setString('role', role);
    await prefs.setString('token', token);
  }


}
