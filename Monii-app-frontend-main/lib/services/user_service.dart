import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monii/config/api_config.dart';
import 'package:monii/config/session_manager.dart';

class UserService {
  static Future<Map<String, dynamic>?> getUserProfile() async {
    String? token = await SessionManager.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.userProfileEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  static Future<String?> getUserLanguage() async {
    String? token = await SessionManager.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.userLanguageEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['language'] as String?;
    } else {
      return null;
    }
  }

  static Future<String?> getUserCurrency() async {
    String? token = await SessionManager.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.userCurrencyEndpoint}"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['currency'] as String?;
    } else {
      return null;
    }
  }
}