import 'package:flutter/material.dart';
import 'package:monii/services/transaction_service.dart';
import 'package:monii/config/session_manager.dart';
import 'package:flutter/services.dart';

class AddBudgetScreen extends StatefulWidget {
  @override
  _AddBudgetScreenState createState() => _AddBudgetScreenState();
}

class _AddBudgetScreenState extends State<AddBudgetScreen> {
  final _formKey = GlobalKey<FormState>();
  double? _amount;
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
      setState(() {
        _categories = categories;
        _isLoading = false;
      });
    } catch (error) {
      debugPrint('Error fetching categories: $error');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _submitBudget() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });

      final token = await SessionManager.getToken();
      if (token == null) throw Exception('Token not found');

      final budgetData = {
        "amount": _amount,
        "categoryId": _categoryId,
      };

      await TransactionService.addBudget(token, budgetData);
      Navigator.pop(context); // Go back after successful submission
    } catch (error) {
      debugPrint('Error adding budget: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add budget')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Add Budget')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Add Budget')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Amount'),
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*')),
                  ],
                  validator: (value) => value == null || double.tryParse(value) == null ? 'Enter a valid amount' : null,
                  onSaved: (value) => _amount = double.tryParse(value!),
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
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitBudget,
                        child: const Text('Add Budget'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}