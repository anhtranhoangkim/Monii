import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:monii/services/transaction_service.dart';
import 'package:monii/config/session_manager.dart';
import 'package:monii/views/auth/login_screen.dart';
import 'package:monii/widgets/shared_fab.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  double income = 0.0;
  double expenditure = 0.0;
  double balance = 0.0;
  List<Map<String, dynamic>> recentTransactions = [];
  List<Map<String, dynamic>> trendData = [];
  bool isLoading = true;
  String currencySymbol = '\$'; // Default currency symbol
  bool isFabOpen = false;
  late AnimationController _fabController;

  @override
  void initState() {
    super.initState();
    _fabController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    fetchHomeData();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> fetchHomeData() async {
    try {
      final token = await SessionManager.getToken();
      final selectedCurrency = await SessionManager.getCurrency();
      if (token == null) throw Exception('Token not found');

      // Load the currency symbol from currencies.json
      final symbol = await _getCurrencySymbol(selectedCurrency ?? 'USD');

      final results = await Future.wait([
        TransactionService.getTotalIncome(token),
        TransactionService.getTotalExpenditure(token),
        TransactionService.getTotalBalance(token),
        TransactionService.getRecentTransactions(token),
        TransactionService.getMonthlyTrends(token),
      ]);

      setState(() {
        currencySymbol = symbol;
        income = (results[0] as num).toDouble();
        expenditure = (results[1] as num).toDouble();
        balance = (results[2] as num).toDouble();

        // Sort recent transactions by id in descending order and take the top 5
        recentTransactions = List<Map<String, dynamic>>.from(results[3] as List)
            ..sort((a, b) => (b['id'] as int).compareTo(a['id'] as int));
        recentTransactions = recentTransactions.take(5).toList();

        trendData = List<Map<String, dynamic>>.from(results[4] as List);
        isLoading = false;
      });
    } catch (_) {
      setState(() {
        isLoading = false;
        income = 1200.0;
        expenditure = 800.0;
        balance = 400.0;
        trendData = List.generate(6, (index) => {
          "month": index + 1,
          "income": 1000 + index * 100,
          "expenditure": 600 + index * 80,
        });
        recentTransactions = List.generate(3, (index) => {
          "name": "Sample ${index + 1}",
          "categoryType": index % 2,
          "amount": 50 + index * 20,
        });
      });
    }
  }

  Future<String> _getCurrencySymbol(String currencyCode) async {
    try {
      final String jsonString = await rootBundle.loadString('assets/currencies.json');
      final Map<String, dynamic> currencies = json.decode(jsonString);

      if (currencies.containsKey(currencyCode)) {
        return currencies[currencyCode]['symbol'] ?? currencyCode;
      } else {
        return currencyCode; // Fallback to currency code if symbol is not found
      }
    } catch (e) {
      debugPrint('Error loading currency symbol: $e');
      return currencyCode; // Fallback to currency code on error
    }
  }

  String formatCurrency(double value) {
    return NumberFormat.currency(symbol: currencySymbol).format(value);
  }

  List<FlSpot> getIncomeSpots() {
    return trendData.map((e) {
      final month = e['month'] as int;
      final income = (e['income'] as num).toDouble();
      return FlSpot(month.toDouble(), income);
    }).toList();
  }

  List<FlSpot> getExpenditureSpots() {
    return trendData.map((e) {
      final month = e['month'] as int;
      final expenditure = (e['expenditure'] as num).toDouble();
      return FlSpot(month.toDouble(), expenditure);
    }).toList();
  }

  void handleLogout() {
    SessionManager.logout(); // Ensure this method clears session data
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void toggleFab() {
    setState(() {
      isFabOpen = !isFabOpen;
      isFabOpen ? _fabController.forward() : _fabController.reverse();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          formatCurrency(balance),
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: handleLogout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  _buildAmountCard("Income", income),
                  const SizedBox(width: 16),
                  _buildAmountCard("Expenditure", expenditure),
                ],
              ),
              const SizedBox(height: 24),
              _buildLineChart(),
              const SizedBox(height: 24),
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Recent Transactions", style: Theme.of(context).textTheme.titleMedium),
              ),
              const SizedBox(height: 12),
              _buildRecentTable(),
            ],
          ),
        ),
      ),
      floatingActionButton: SharedFAB(
        fabController: _fabController,
        isFabOpen: isFabOpen,
        toggleFab: toggleFab,
        onRefresh: fetchHomeData,
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildAmountCard(String label, double value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: Column(
          children: [
            Text(label, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 8),
            Text(formatCurrency(value), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    if (trendData.isEmpty) {
      return Center(
        child: Text('No data available to display the chart'),
      );
    }

    return AspectRatio(
      aspectRatio: 1.7,
      child: LineChart(
        LineChartData(
          lineBarsData: [
            // Line for Income
            LineChartBarData(
              spots: getIncomeSpots(),
              isCurved: false, // Disable curved lines
              color: Colors.green,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              barWidth: 3,
            ),
            // Line for Expenditure
            LineChartBarData(
              spots: getExpenditureSpots(),
              isCurved: false, // Disable curved lines
              color: Colors.red,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(show: false),
              barWidth: 3,
            ),
          ],
          titlesData: FlTitlesData(
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, _) {
                  const months = [];
                  int index = value.toInt() - 1;
                  if (index >= 0 && index < months.length) {
                    return Text(months[index]);
                  }
                  return const Text('');
                },
              ),
            ),
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                getTitlesWidget: (value, _) => Text(value.toStringAsFixed(0)),
              ),
            ),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            border: const Border(
              left: BorderSide(color: Colors.black, width: 1),
              bottom: BorderSide(color: Colors.black, width: 1),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRecentTable() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: Column(
        children: recentTransactions.map((tx) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                const Icon(Icons.circle, size: 12, color: Colors.blueGrey),
                const SizedBox(width: 8),
                Expanded(child: Text(tx['name'] ?? '')),
                
                const SizedBox(width: 12),
                Text(formatCurrency(tx['amount'].toDouble())),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return BottomNavigationBar(
      currentIndex: 0,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == 0) return;
        if (index == 1) Navigator.pushNamed(context, '/reports');
        if (index == 2) Navigator.pushNamed(context, '/chat');
        if (index == 3) Navigator.pushNamed(context, '/account_screen');
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: "Reports"),
        BottomNavigationBarItem(icon: Icon(Icons.smart_toy), label: "AI Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
      ],
    );
  }
}
