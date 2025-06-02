import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:math';

import 'package:monii/config/session_manager.dart';

class ExpenditureScreen extends StatefulWidget {
  @override
  _ExpenditureScreenState createState() => _ExpenditureScreenState();
}

class _ExpenditureScreenState extends State<ExpenditureScreen> {
  List<Map<String, dynamic>> expenseCategories = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchExpenseData();
  }

  Future<void> fetchExpenseData() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/analytics/category-summary?type=0'),
        headers: {
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List;
        setState(() {
          expenseCategories = data.map((item) {
            return {
              "categoryId": item['categoryId'],
              "categoryName": item['categoryName'],
              "total": (item['total'] ?? 0.0).toDouble(),
              "budget": item['budget'],
              "description": item['description'] ?? '',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to fetch expenditure data');
      }
    } catch (error) {
      debugPrint('Error fetching expenditure data: $error');
      setState(() {
        isLoading = false;
      });
    }
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: "\$", decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text("Expenditure")),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Expenditure")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPieChart(),
            const SizedBox(height: 24),
            _buildCategoryProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildPieChart() {
    final total = expenseCategories.fold(0.0, (sum, item) => sum + item['total']);

    return AspectRatio(
      aspectRatio: 1.4,
      child: PieChart(
        PieChartData(
          sectionsSpace: 3,
          centerSpaceRadius: 40,
          sections: expenseCategories.map((item) {
            final percentage = total == 0 ? 0 : (item['total'] / total) * 100;
            return PieChartSectionData(
              value: item['total'],
              title: "${percentage.toStringAsFixed(1)}%",
              color: _getCategoryColor(item['categoryName']),
              radius: 70,
              titleStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildCategoryProgress() {
    return Column(
      children: expenseCategories.map((category) {
        final categoryId = category['categoryId'];
        final total = category['total'];
        final budget = category['budget'];
        final progress = budget != null && budget > 0 ? total / budget : 1.0;
        final color = _getCategoryColor(category['categoryName']);

        return GestureDetector(
          onTap: () {
            print("Navigating to CategoryDetailScreen with categoryId: $categoryId");
            Navigator.pushNamed(
              context,
              '/category-detail',
              arguments: {
                'categoryId': categoryId,
              },
            );
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      category['categoryName'],
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      "\$${total.toStringAsFixed(2)}",
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                SizedBox(
                  width: double.infinity,
                  child: LinearProgressIndicator(
                    value: progress > 1.0 ? 1.0 : progress,
                    backgroundColor: Colors.grey[300],
                    color: color,
                    minHeight: 6,
                  ),
                ),
                if (budget != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Text(
                      "\$${(budget - total).toStringAsFixed(2)} left",
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  final Map<String, Color> _categoryColorCache = {};

  Color _getCategoryColor(String categoryName) {
    if (_categoryColorCache.containsKey(categoryName)) {
      return _categoryColorCache[categoryName]!;
    }

    final hash = categoryName.hashCode;
    final rand = Random(hash);

    final color = Color.fromARGB(
      255,
      100 + rand.nextInt(155),
      100 + rand.nextInt(155),
      100 + rand.nextInt(155),
    );

    _categoryColorCache[categoryName] = color;
    return color;
  }
}
