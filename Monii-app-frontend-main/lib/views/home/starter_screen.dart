import 'package:flutter/material.dart';
import 'package:monii/config/session_manager.dart';
import 'package:monii/views/home/home_screen.dart';

class StarterScreen extends StatefulWidget {
  @override
  _StarterScreenState createState() => _StarterScreenState();
}

class _StarterScreenState extends State<StarterScreen> {
  String? _selectedLanguage;
  String? _selectedCurrency;

  final List<String> languages = ['en', 'vi'];
  final List<String> currencies = ['USD', 'VND'];

  void _continue() async {
    if (_selectedLanguage != null && _selectedCurrency != null) {
      await SessionManager.setLanguage(_selectedLanguage!);
      await SessionManager.setCurrency(_selectedCurrency!);
      await SessionManager.setSetupComplete(true);

      Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select both language and currency')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Welcome")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text("Select your language"),
            DropdownButton<String>(
              value: _selectedLanguage,
              hint: Text("Choose Language"),
              onChanged: (val) => setState(() => _selectedLanguage = val),
              items: languages.map((lang) {
                return DropdownMenuItem(
                  value: lang,
                  child: Text(lang.toUpperCase()),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text("Select your currency"),
            DropdownButton<String>(
              value: _selectedCurrency,
              hint: Text("Choose Currency"),
              onChanged: (val) => setState(() => _selectedCurrency = val),
              items: currencies.map((currency) {
                return DropdownMenuItem(
                  value: currency,
                  child: Text(currency),
                );
              }).toList(),
            ),
            Spacer(),
            ElevatedButton(
              onPressed: _continue,
              child: Text("Continue"),
            )
          ],
        ),
      ),
    );
  }
}
