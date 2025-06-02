import 'dart:convert';
import 'package:http/http.dart' as http;

class TransactionService {
  static const String baseUrl = 'http://10.0.2.2:8080/api'; // Replace with your API base URL

  static Future<double> getTotalIncome(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics/total-income'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = res.body.trim();
      return double.tryParse(body) ?? (json.decode(body) as num).toDouble();
    } else {
      throw Exception('Failed to load total income. Status: ${res.statusCode}');
    }
  }

  static Future<double> getTotalExpenditure(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics/total-expenditure'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = res.body.trim();
      return double.tryParse(body) ?? (json.decode(body) as num).toDouble();
    } else {
      throw Exception('Failed to load total expenditure. Status: ${res.statusCode}');
    }
  }

  static Future<double> getTotalBalance(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics/total-balance'),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (res.statusCode == 200) {
      final body = res.body.trim();
      return double.tryParse(body) ?? (json.decode(body) as num).toDouble();
    } else {
      throw Exception('Failed to load total balance. Status: ${res.statusCode}');
    }
  }

  static Future<List<Map<String, dynamic>>> getRecentTransactions(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/transactions'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return (json.decode(res.body) as List).cast<Map<String, dynamic>>().take(5).toList();
    } else {
      throw Exception('Failed to load recent transactions');
    }
  }

  static Future<List<Map<String, dynamic>>> getMonthlyTrends(String token) async {
    final res = await http.get(
      Uri.parse('$baseUrl/analytics/month-trends'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (res.statusCode == 200) {
      return (json.decode(res.body) as List).cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load monthly trends');
    }
  }

  // Method to add a transaction
  static Future<void> addTransaction(String token, Map<String, dynamic> transactionData) async {
    final url = Uri.parse('$baseUrl/transactions');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(transactionData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add transaction: ${response.body}');
    }
  }

  // Method to add a category
  static Future<void> addCategory(String token, Map<String, dynamic> categoryData) async {
    final url = Uri.parse('$baseUrl/categories');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(categoryData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add category: ${response.body}');
    }
  }

  // Method to add a budget
  static Future<void> addBudget(String token, Map<String, dynamic> budgetData) async {
    final url = Uri.parse('$baseUrl/budgets');
    final response = await http.post(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: jsonEncode(budgetData),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add budget: ${response.body}');
    }
  }

  // Method to fetch categories (already used in your code)
  static Future<List<Map<String, dynamic>>> getCategories(String token) async {
    final url = Uri.parse('$baseUrl/categories');
    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to fetch categories: ${response.body}');
    }

    final List<dynamic> data = jsonDecode(response.body);
    return data.map((category) => category as Map<String, dynamic>).toList();
  }

    // Fetch the transaction details by transactionId
  static Future<Map<String, dynamic>> getTransaction(int transactionId, String token) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');

    final response = await http.get(url, headers: {
      'Authorization': 'Bearer $token',
    });

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load transaction');
    }
  }

  // Update an existing transaction
  static Future<void> updateTransaction(int transactionId, String token, Map<String, dynamic> transactionData) async {
    final url = Uri.parse('$baseUrl/transactions/$transactionId');

    final response = await http.put(
      url,
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: json.encode(transactionData),
    );

    if (response.statusCode != 200) {
      throw Exception('Failed to update transaction');
    }
  }
}