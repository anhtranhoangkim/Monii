import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:monii/config/session_manager.dart';

class CategoryService {
  static const String baseUrl = 'http://10.0.2.2:8080/api';

  // Fetch categories by type (type = 1 for income, type = 0 for expenditure)
  static Future<List<Map<String, dynamic>>> fetchCategoriesByType(int type) async {
    final token = await SessionManager.getToken(); // Retrieve the token
    if (token == null) {
      throw Exception('User is not authenticated');
    }

    final url = Uri.parse('$baseUrl/categories?type=$type');
    try {
      final response = await http.get(
        url,
        headers: {
          'Authorization': 'Bearer $token', // Include the token in the headers
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        return data.map((item) {
          return {
            "id": item['id'],
            "name": item['name'],
            "type": item['type'],
            "icon": item['icon'],
            "description": item['description'],
            "amount": item['amount'] ?? 0.0, // Default amount if not provided
          };
        }).toList();
      } else {
        throw Exception('Failed to fetch categories: ${response.statusCode}');
      }
    } catch (error) {
      throw Exception('Error fetching categories: $error');
    }
  }
}