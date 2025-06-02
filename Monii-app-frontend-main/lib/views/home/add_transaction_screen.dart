import 'package:flutter/material.dart';
import 'package:monii/services/transaction_service.dart';
import 'package:monii/config/session_manager.dart';
import 'package:flutter/services.dart';

class AddTransactionScreen extends StatefulWidget {
  @override
  _AddTransactionScreenState createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  double? _amount;
  String? _note;
  DateTime? _transactionDate;
  String _paymentMethod = 'CASH';
  int? _categoryId;
  List<Map<String, dynamic>> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final token = await SessionManager.getToken();
      if (token == null) throw Exception('Token not found');
      final categories = await TransactionService.getCategories(token);
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching categories: $error');
      if (!mounted) return; // Check if the widget is still in the tree
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitTransaction() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      final token = await SessionManager.getToken();
      if (token == null) throw Exception('Token not found');

      final transactionData = {
        "name": _name,
        "amount": _amount,
        "note": _note,
        "transactionDate": _transactionDate?.toIso8601String(),
        "paymentMethod": _paymentMethod,
        "categoryId": _categoryId,
      };

      await TransactionService.addTransaction(token, transactionData);

      Navigator.pop(context, true); // Return true to indicate success
    } catch (error) {
      debugPrint('Error adding transaction: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add transaction')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Transaction')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Transaction')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) => value == null || value.isEmpty ? 'Name is required' : null,
                  onSaved: (value) => _name = value,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true), // Numeric keyboard with decimal support
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')), // Allow only numbers and one decimal point
                  ],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Amount is required';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Enter a valid number';
                    }
                    return null;
                  },
                  onSaved: (value) => _amount = double.tryParse(value!),
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Note'),
                  onSaved: (value) => _note = value,
                ),
                const SizedBox(height: 16),
                Text('Transaction Date'),
                ElevatedButton(
                  onPressed: () async {
                    final selectedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (selectedDate != null) {
                      setState(() {
                        _transactionDate = selectedDate;
                      });
                    }
                  },
                  child: Text(_transactionDate == null
                      ? 'Select Date'
                      : _transactionDate!.toLocal().toString().split(' ')[0]),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: _paymentMethod,
                  decoration: const InputDecoration(labelText: 'Payment Method'),
                  items: ['CASH', 'CARD', 'BANK_TRANSFER', 'E_WALLET', 'OTHER']
                      .map((method) => DropdownMenuItem(
                            value: method,
                            child: Text(method),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: _categories
                      .map((category) => DropdownMenuItem<int>(
                            value: category['id'] as int,
                            child: Text(category['name']),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() => _categoryId = value),
                  validator: (value) => value == null ? 'Category is required' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submitTransaction,
                  child: const Text('Add Transaction'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}