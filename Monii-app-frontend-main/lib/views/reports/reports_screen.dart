import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:monii/widgets/shared_fab.dart';

class ReportsScreen extends StatefulWidget {
  @override
  _ReportsScreenState createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> with SingleTickerProviderStateMixin {
  late AnimationController _fabController;
  bool isFabOpen = false;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  void toggleFab() {
    setState(() {
      isFabOpen = !isFabOpen;
      isFabOpen ? _fabController.forward() : _fabController.reverse();
    });
  }

  final List<Map<String, dynamic>> incomeCategories = [
    {"name": "Category1", "amount": 40.00},
    {"name": "Category2", "amount": 2.00},
    {"name": "Category3", "amount": 2.00},
    {"name": "Category4", "amount": 40.00},
    {"name": "Category5", "amount": 2.00},
  ];

  final List<Map<String, dynamic>> expenditureCategories = [
    {"name": "Category6", "amount": 40.00},
    {"name": "Category7", "amount": 2.00},
    {"name": "Category8", "amount": 2.00},
    {"name": "Category9", "amount": 40.00},
    {"name": "Category10", "amount": 2.00},
  ];

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: "\$", decimalDigits: 2).format(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/income'); // Navigate to IncomeScreen
              },
              child: _buildCategoryCard("Income"),
            ),
            const SizedBox(height: 16),
            GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/expenditure'); // Navigate to ExpenditureScreen
              },
              child: _buildCategoryCard("Expenditure"),
            ),
          ],
        ),
      ),
      floatingActionButton: SharedFAB(
        fabController: _fabController,
        isFabOpen: isFabOpen,
        toggleFab: toggleFab,
      ),
    );
  }

  Widget _buildCategoryCard(String title) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16),
          ],
        ),
      ),
    );
  }
}