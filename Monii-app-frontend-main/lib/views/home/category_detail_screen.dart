import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'package:monii/config/session_manager.dart';
import 'package:monii/views/home/transaction_detail_screen.dart';

class CategoryDetailScreen extends StatefulWidget {
  const CategoryDetailScreen({Key? key}) : super(key: key);

  @override
  _CategoryDetailScreenState createState() => _CategoryDetailScreenState();
}

class _CategoryDetailScreenState extends State<CategoryDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;

  late int categoryId;
  late String categoryName;
  String? description;
  late int type;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    categoryId = args['categoryId'];

    fetchCategoryDetails();
    fetchTransactions();
  }

  Future<void> fetchCategoryDetails() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/categories/$categoryId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          categoryName = data['name'];
          description = data['description'] ?? '';
          type = data['type'];
          _nameController.text = categoryName;
          _descriptionController.text = description!;
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load category details");
      }
    } catch (e) {
      debugPrint("Error loading category details: $e");
    }
  }

  Future<void> fetchTransactions() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.get(
        Uri.parse('http://10.0.2.2:8080/api/transactions/$categoryId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _transactions = List<Map<String, dynamic>>.from(data);
          _isLoading = false;
        });
      } else {
        throw Exception("Failed to load transactions");
      }
    } catch (e) {
      debugPrint("Error loading transactions: $e");
      // setState(() => _isLoading = false);
    }
  }

  Future<void> updateCategory() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.put(
        Uri.parse('http://10.0.2.2:8080/api/categories/$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({
          "name": _nameController.text,
          "description": _descriptionController.text,
          "type": type,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category updated successfully")),
        );

      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Failed to update category")),
        );
      }
    } catch (e) {
      debugPrint("Update category error: $e");
    }
  }

  Future<void> deleteCategory() async {
    try {
      final token = await SessionManager.getToken();
      final response = await http.delete(
        Uri.parse('http://10.0.2.2:8080/api/categories/$categoryId'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category deleted successfully")),
        );
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Category deleted successfully")),
        );
      }
    } catch (e) {
      debugPrint("Delete category error: $e");
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Category Detail"),
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameController,
                          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Category Name",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _descriptionController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Description",
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {},
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: updateCategory,
                        icon: const Icon(Icons.save),
                        label: const Text("Update"),
                      ),
                      OutlinedButton.icon(
                        onPressed: deleteCategory,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text("Delete"),
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    "Recent Records",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.grey[100],
                      ),
                      child: ListView.builder(
                        itemCount: _transactions.length,
                        itemBuilder: (context, index) {
                          final tx = _transactions[index];
                          return ListTile(
                            title: Text(tx['name'] ?? ''),
                            subtitle: Text(
                              DateFormat.yMMMd().format(DateTime.parse(tx['transactionDate'])),
                            ),
                            trailing: Text(
                              NumberFormat.currency(symbol: "\$").format(tx['amount']),
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/transaction-detail',
                                arguments: {
                                  'transactionId': tx['id'],
                                },
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
