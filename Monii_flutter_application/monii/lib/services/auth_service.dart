import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monii/config/session_manager.dart';
import 'package:monii/config/api_config.dart';

class AuthService {
  // Register
  static Future<bool> registerUser(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8080/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email" : email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Login
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      // Directly save the JWT token from the response body
      await SessionManager.saveToken(response.body);
      return true;
    } else {
      return false;
    }
  }
}
