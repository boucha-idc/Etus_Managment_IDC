import 'dart:convert';
import 'package:idc_etus_bechar/models/line.dart';
import 'package:idc_etus_bechar/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';
class ApiServiceController {
  final String baseUrl = "https://idevelopcompany.dz/IDC%20Projects/BusManagement/api";

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<Map<String, dynamic>?> getBusByReference(String reference) async {
    final url = Uri.parse('$baseUrl/buses/qrcode/$reference');

    try {
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
        final responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic>) {
          if (responseBody['success'] == true && responseBody['data'] != null) {
            final data = responseBody['data'];

            if (data is Map<String, dynamic>) {
              return data;
            } else {
              print("Unexpected data format: ${data.runtimeType}");
              return null;
            }
          } else {
            print("No bus found with the reference: $reference");
            return null;
          }
        } else {
          print("Unexpected response format: ${responseBody.runtimeType}");
          return null;
        }
      } else {
        print("Failed to load bus data, status code: ${response.statusCode}");
        return null;
      }
    } catch (e) {
      print("Error verifying bus reference: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>> getTokenAndUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');
    int userId = prefs.getInt('user_id') ?? 0;
    return {
      'token': token,
      'user_id': userId,
    };
  }

  Future<User> fetchUserProfile() async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      print("Token: $token");
      print("User ID: $userId");

      if (token == null) {
        throw Exception("Token is not available.");
      }

      if (userId == 0) {
        throw Exception("User ID is null or 0.");
      }

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("Response Status fetch data profile: ${response.statusCode}");
      print("Response Body fetch data profile: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        print("Response JSON fetch data profile: $result");

        // Create a User object from the 'data' key in the response
        User user = User.fromJson(result['data']);

        return user; // Return the User object
      } else {
        throw Exception("Error: ${response.statusCode} - ${response.body}");
      }
    } catch (e) {
      print("Exception Occurred: $e");
      throw Exception("Failed to fetch user profile: $e");
    }
  }

  /*Future<Map<String, dynamic>> updateEmployeeDetails(
      String password, {String? updateType, File? imageFile}) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is not available.");
      if (userId == 0) throw Exception("User ID is null or 0.");

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");

      if (updateType == 'password') {
        // Handle password update with PUT request
        final response = await http.put(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"password": password}),
        ).timeout(Duration(seconds: 60));

        if (response.statusCode == 200) {
          print("Password update successful: ${response.body}");
          return jsonDecode(response.body);
        } else {
          print("Failed to update password, Status Code: ${response.statusCode}");
          throw Exception('Failed to update password: ${response.body}');
        }
      } else if (updateType == 'image' && imageFile != null) {
        String imageFileName = imageFile.path.split('/').last;
        String imageFileUrl =
            "https://idevelopcompany.dz/IDC%20Projects/BusManagement/storage/$imageFileName";
        print("Final Image URL: $imageFileUrl");
        final response = await http.put(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"image": imageFileUrl}),
        ).timeout(Duration(seconds: 60));

        if (response.statusCode == 200) {
          print("Image update successful: ${response.body}");
          return jsonDecode(response.body);
        } else {
          print("Failed to update image, Status Code: ${response.statusCode}");
          throw Exception('Failed to update image: ${response.body}');
        }
      } else {
        throw Exception("Invalid update type or missing image file.");
      }
    } catch (e) {
      print("Exception Occurred: $e");
      throw Exception("Failed to update details: $e");
    }
  }*/
  /* Future<Map<String, dynamic>> updateEmployeeDetails(
      String password, {
        String? updateType,
        File? imageFile,
      }) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is not available.");
      if (userId == 0) throw Exception("User ID is null or 0.");

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");

      if (updateType == 'password') {
        final response = await http.put(
          Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"password": password}),
        ).timeout(Duration(seconds: 60));

        if (response.statusCode == 200) {
          print("Password update successful: ${response.body}");
          return jsonDecode(response.body);
        } else {
          throw Exception('Failed to update password: ${response.body}');
        }
      } else if (updateType == 'image' && imageFile != null) {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl))
          ..headers.addAll({
            "Authorization": "Bearer $token",
          })
          ..files.add(
            await http.MultipartFile.fromPath(
              imageFile.path,
            ),
          );

        var response = await request.send();

        if (response.statusCode == 200) {
          var responseBody = await response.stream.bytesToString();
          var jsonData = jsonDecode(responseBody);
          print("Image update successful: $jsonData");

          return jsonData;
        } else {
          throw Exception('Failed to update image: ${response.statusCode}');
        }
      } else {
        throw Exception("Invalid update type or missing image file.");
      }
    } catch (e) {
      print("Exception Occurred: $e");
      throw Exception("Failed to update details: $e");
    }
  }*/

  /*Future<List<Map<String, dynamic>>> fetchLineNames() async {
    try {
      // API endpoint
      String apiUrl = "$baseUrl/lines";

      // Get token and user ID
      final result = await getTokenAndUserId();
      String? token = result['token'];

      // Make the HTTP GET request
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Debug: Log response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check if the response status is 200 (OK)
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract lines from the 'data' field
        List<dynamic> rawLines = data['data'];
        List<Map<String, dynamic>> lineNames = rawLines.map((line) {
          return {
            'id': line['id'],
            'name': line['name'],
          };
        }).toList();

        print('Line Names: $lineNames');

        return lineNames;
      } else {
        throw Exception('Failed to load lines: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Debug: Log the error
      print('Error fetching lines: $e');
      throw Exception('Failed to load lines: $e');
    }}*/

  Future<List<Map<String, dynamic>>> fetchLineNames() async {
    try {
      // API endpoint
      String apiUrl = "$baseUrl/lines";

      // Get token and user ID
      final result = await getTokenAndUserId();
      String? token = result['token'];

      // Make the HTTP GET request
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      // Debug: Log response status and body
      print('Response Status: ${response.statusCode}');
      print('Response Body: ${response.body}');

      // Check if the response status is 200 (OK)
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Extract lines from the 'data' field
        List<dynamic> rawLines = data['data'];
        List<Map<String, dynamic>> lineNames = rawLines.map((line) {
          return {
            'id': line['id'],
            'name': line['name'],
            'arrival_name': line['arrival']['name'],
          };
        }).toList();

        print('Line Names with Arrival: $lineNames');

        return lineNames;
      } else {
        throw Exception('Failed to load lines: HTTP ${response.statusCode}');
      }
    } catch (e) {
      // Debug: Log the error
      print('Error fetching lines: $e');
      throw Exception('Failed to load lines: $e');
    }
  }

  Future<bool> saveBusReport(Map<String, dynamic> busData) async {
    final url = Uri.parse(
        '$baseUrl/controls'); // Replace with your API endpoint

    try {
      // Assuming you're using a token for authentication
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not available.");
      }

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode(busData), // Convert map to JSON
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);
        if (responseBody['success'] == true) {
          print("Bus report saved successfully");
          return true;
        } else {
          print("Failed to save bus report");
          return false;
        }
      } else {
        print("Failed to save bus report. Status code: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error saving bus report: $e");
      return false;
    }
  }

  Future<List<Map<String, dynamic>>?> getAllControllerReports() async {
    final url = Uri.parse(
        '$baseUrl/controls'); // Replace with your API endpoint

    try {
      final token = await getToken();
      if (token == null) {
        throw Exception("Token is not available.");
      }

      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseBody = json.decode(response.body);

        if (responseBody is Map<String, dynamic> &&
            responseBody['success'] == true) {
          // Assuming the 'data' field contains the list of reports
          var reports = responseBody['data'] as List;
          return reports.map((report) => report as Map<String, dynamic>)
              .toList();
        } else {
          print("No reports found or failure in response.");
          return null;
        }
      } else {
        print("Failed to load controller reports. Status code: ${response
            .statusCode}");
        return null;
      }
    } catch (e) {
      print("Error fetching controller reports: $e");
      return null;
    }
  }
 /* static Future<http.StreamedResponse> postFiles({
    required String password,
    required String path,
    Map<String, dynamic>? data,
    required List<PlatformFile> files,
    required String filesAttribute,
    bool isAuthenticated = false,
  }) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is not available.");
      if (userId == 0) throw Exception("User ID is null or 0.");

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      final headers = await _getUploadFilesHeaders(isAuthenticated);
      request.headers.addAll(headers);

      int i = 0;
      if (files.isNotEmpty) {
        for (var file in files) {
          File f = File(file.path!);
          var stream = http.ByteStream(f.openRead());
          var length = await f.length();
          request.files.add(
            http.MultipartFile(
              filesAttribute + "$i",
              stream,
              length,
              filename: file.path!.split('/').last,
            ),
          );
          i++;
        }
      }

      if (data != null) {
        for (String key in data.keys) {
          request.fields[key] = data[key].toString();
        }
      }

      var response = await request.send();
      return response;
    } catch (e) {
      print('Error uploading files: $e');
      throw Exception("Failed to upload files: $e");
    }
  }

  static Future<http.StreamedResponse> postOneFile({
    required String password,
    required String path,
    Map<String, dynamic>? data,
    required File? file,
    required String fileAttribute,
    bool isAuthenticated = false,
  }) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is not available.");
      if (userId == 0) throw Exception("User ID is null or 0.");

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");

      var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
      final headers = await _getUploadFilesHeaders(isAuthenticated);
      request.headers.addAll(headers);

      if (fileAttribute.isNotEmpty && file != null) {
        var stream1 = http.ByteStream(file.openRead());
        var length1 = await file.length();
        request.files.add(
          http.MultipartFile(
            fileAttribute,
            stream1,
            length1,
            filename: file.path.split('/').last,
          ),
        );
      }

      if (data != null) {
        for (String key in data.keys) {
          if (data[key] != null) {
            request.fields[key] = data[key];
          }
        }
      }

      var response = await request.send();
      return response;
    } catch (e) {
      print("Error uploading file: $e");
      throw Exception("Failed to upload file: $e");
    }
  }*/






  /// Function to update the employee password
  Future<Map<String, dynamic>> updatePassword(String password) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is not available.");
      if (userId == 0) throw Exception("User ID is null or 0.");

      String apiUrl = "$baseUrl/employees/$userId";
      print("API URL: $apiUrl");


      final response = await http.put(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({"password": password}),
      );

      if (response.statusCode == 200) {
        print("Password updated successfully!");
        return jsonDecode(response.body);
      } else {
        throw Exception("Failed to update password: ${response.body}");
      }
    } catch (e) {
      print("Password Update Error: $e");
      throw Exception("Error updating password.");
    }
  }

  Future<String> uploadImage(File imageFile, String token, int userId) async {
    try {
      var uri = Uri.parse("$baseUrl/employees/$userId");
      var request = http.MultipartRequest("PUT", uri);

      request.headers.addAll({
        "Authorization": "Bearer $token",
        "Accept": "application/json",
      });
      request.files.add(await http.MultipartFile.fromPath("image", imageFile.path));
      var response = await request.send();

      var responseData = await response.stream.bytesToString();
      print("Response from server: $responseData");

      var jsonResponse = jsonDecode(responseData);

      if (jsonResponse["success"] == true && jsonResponse.containsKey("data") && jsonResponse["data"].containsKey("image")) {
        return jsonResponse["data"]["image"];
      } else {
        throw Exception("Server did not return the image URL. Response: $jsonResponse");
      }

    } catch (e) {
      print("Image Upload Error: $e");
      throw Exception("Error uploading image.");
    }
  }






  Future<Map<String, dynamic>> updateEmployeeDetails(
      String password, {String? updateType, File? imageFile}) async {
    try {
      final result = await getTokenAndUserId();
      String? token = result['token'];
      int userId = result['user_id'];

      if (token == null) throw Exception("Token is missing.");
      if (userId == 0) throw Exception("User ID is invalid.");

      if (updateType == 'password') {
        return await updatePassword(password);
      } else if (updateType == 'image' && imageFile != null) {
        print("Uploading image...");
        String imageFileName = await uploadImage(imageFile, token, userId);

        if (imageFileName.isEmpty) throw Exception("Image upload failed.");
        print("Image uploaded successfully: $imageFileName");
        String imageFileUrl = "https://idevelopcompany.dz/IDC%20Projects/BusManagement/storage/$imageFileName";
        String apiUrl = "$baseUrl/employees/$userId";

        final response = await http.put(
          Uri.parse(apiUrl),
          headers: {
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({"image": imageFileUrl}),
        );

        if (response.statusCode == 200) {
          print("Profile updated successfully.");
          return jsonDecode(response.body);
        } else {
          throw Exception("Failed to update profile: ${response.body}");
        }
      } else {
        throw Exception("Invalid update type or missing image file.");
      }
    } catch (e) {
      print("Exception Occurred: $e");
      throw Exception("Failed to update employee details.");
    }
  }




}


