import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:monii/config/session_manager.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  String fullName = '';
  String email = '';
  String avatarUrl = '';
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final token = await SessionManager.getToken();
    final url = 'http://10.0.2.2:8080/api/users/me';

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          fullName = data['fullName'] ?? '';
          email = data['email'] ?? '';
          avatarUrl = data['avatarUrl'] ?? '';
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        _showError("Unable to fetch user data. Status ${response.statusCode}");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      _showError("Something went wrong.");
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundImage: avatarUrl.isNotEmpty
                        ? NetworkImage(avatarUrl)
                        : const AssetImage('assets/avatar_placeholder.png') as ImageProvider,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    fullName,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(email, style: const TextStyle(fontSize: 16)),
                ],
              ),
            ),
    );
  }
}
