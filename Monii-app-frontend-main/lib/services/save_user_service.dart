import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monii/models/user_model.dart';

Future<void> saveUserToBackend(User user, String provider, {String? password}) async {
  final response = await http.post(
    Uri.parse('http://localhost:8080/api/auth/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      "id": user.id,
      "fullName": user.fullName,
      "email": user.email,
      "password": password ?? "", 
      "avatarUrl": user.avatarUrl,
      "language": user.language,
      "currency": user.currency,
      "provider": provider,
      "createdAt": user.createdAt.toIso8601String(),
      "updatedAt": user.updatedAt.toIso8601String(),
    }),
  );

  if (response.statusCode == 200) {
    print("User saved to backend successfully");
  } else {
    print("Failed to save user: ${response.body}");
  }
}
