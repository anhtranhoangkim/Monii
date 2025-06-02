import 'package:flutter/material.dart';
import 'package:monii/services/transaction_service.dart';
import 'package:monii/config/session_manager.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _name;
  String? _description;
  String? _icon;
  int _type = 0; // 0 for expenses, 1 for income
  bool _isLoading = false;

  Future<void> _submitCategory() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    try {
      setState(() {
        _isLoading = true;
      });

      final token = await SessionManager.getToken();
      if (token == null) throw Exception('Token not found');

      final categoryData = {
        "name": _name,
        "description": _description,
        // "icon": _icon,
        "type": _type,
      };

      await TransactionService.addCategory(token, categoryData);
      Navigator.pop(context); // Go back after successful submission
    } catch (error) {
      debugPrint('Error adding category: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add category')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Category')),
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
                  decoration: const InputDecoration(labelText: 'Description'),
                  onSaved: (value) => _description = value,
                ),
                // TextFormField(
                //   decoration: const InputDecoration(labelText: 'Icon (URL or name)'),
                //   onSaved: (value) => _icon = value,
                // ),
                const SizedBox(height: 16),
                DropdownButtonFormField<int>(
                  value: _type,
                  decoration: const InputDecoration(labelText: 'Type'),
                  items: [
                    DropdownMenuItem(value: 0, child: Text('Expenses')),
                    DropdownMenuItem(value: 1, child: Text('Income')),
                  ],
                  onChanged: (value) => setState(() => _type = value!),
                ),
                const SizedBox(height: 24),
                _isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: _submitCategory,
                        child: const Text('Add Category'),
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}