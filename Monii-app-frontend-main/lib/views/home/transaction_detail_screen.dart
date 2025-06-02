import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:monii/config/session_manager.dart';

class TransactionDetailScreen extends StatefulWidget {
  const TransactionDetailScreen({Key? key}) : super(key: key);

  @override
  State<TransactionDetailScreen> createState() => _TransactionDetailScreenState();
}

class _TransactionDetailScreenState extends State<TransactionDetailScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  int? _transactionId;
  DateTime? _transactionDate;
  String _paymentMethod = 'CASH';
  int? _categoryId;

  bool _isLoading = true;
  bool _hasError = false;

  List<Map<String, dynamic>> _categories = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    if (args == null || !args.containsKey('transactionId')) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
      return;
    }
    _transactionId = args['transactionId'];
    _fetchInitialData();
  }

  Future<void> _fetchInitialData() async {
    await Future.wait([
      _fetchCategories(),
      _fetchTransactionDetails(),
    ]);
  }

  Future<void> _fetchCategories() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.get(
        Uri.parse("http://10.0.2.2:8080/api/categories"),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _categories = data.cast<Map<String, dynamic>>();
        });
      }
    } catch (e) {
      debugPrint("Error fetching categories: $e");
    }
  }

  Future<void> _fetchTransactionDetails() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/transactions/trans/$_transactionId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _nameController.text = data['name'];
          _amountController.text = data['amount'].toString();
          _noteController.text = data['note'] ?? '';
          _transactionDate = DateTime.parse(data['transactionDate']);
          _paymentMethod = data['paymentMethod'];
          _categoryId = data['categoryId'];
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load transaction");
      }
    } catch (e) {
      debugPrint("Error loading transaction: $e");
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  Future<void> _updateTransaction() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      final token = await SessionManager.getToken();
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/transactions/$_transactionId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          "name": _nameController.text,
          "amount": double.tryParse(_amountController.text) ?? 0.0,
          "note": _noteController.text,
          "transactionDate": _transactionDate?.toIso8601String(),
          "paymentMethod": _paymentMethod,
          "categoryId": _categoryId,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction updated successfully")),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Update failed");
      }
    } catch (e) {
      debugPrint("Error updating: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to update transaction")),
      );
    }
  }

  Future<void> _deleteTransaction() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/transactions/trans/$_transactionId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Transaction deleted successfully")),
        );
        Navigator.pop(context, true);
      } else {
        throw Exception("Delete failed");
      }
    } catch (e) {
      debugPrint("Delete error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Transaction deleted successfully")),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_hasError) {
      return const Scaffold(body: Center(child: Text("Failed to load transaction details")));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Transaction")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
              ),
              TextFormField(
                controller: _amountController,
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Amount is required';
                  if (double.tryParse(value) == null) return 'Enter a valid number';
                  return null;
                },
              ),
              TextFormField(
                controller: _noteController,
                decoration: const InputDecoration(labelText: 'Note'),
              ),
              const SizedBox(height: 16),
              Text("Transaction Date"),
              ElevatedButton(
                onPressed: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _transactionDate ?? DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (date != null) {
                    setState(() => _transactionDate = date);
                  }
                },
                child: Text(_transactionDate == null
                    ? 'Select Date'
                    : DateFormat('yyyy-MM-dd').format(_transactionDate!)),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _paymentMethod,
                decoration: const InputDecoration(labelText: 'Payment Method'),
                items: ['CASH', 'CARD', 'BANK_TRANSFER', 'E_WALLET', 'OTHER']
                    .map((method) => DropdownMenuItem(value: method, child: Text(method)))
                    .toList(),
                onChanged: (val) => setState(() => _paymentMethod = val!),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<int>(
                value: _categoryId,
                decoration: const InputDecoration(labelText: 'Category'),
                items: _categories
                    .map((cat) => DropdownMenuItem<int>(value: cat['id'] as int, child: Text(cat['name'] as String)))
                    .toList(),
                onChanged: (val) => setState(() => _categoryId = val),
                validator: (value) => value == null ? 'Category is required' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: _updateTransaction,
                icon: const Icon(Icons.save),
                label: const Text('Update Transaction'),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _deleteTransaction,
                icon: const Icon(Icons.delete_outline),
                label: const Text('Delete Transaction'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: Colors.red,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
