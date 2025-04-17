import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final Dio _dio = Dio(BaseOptions(
    baseUrl: "https://10.0.2.2:8080/",
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
    headers: {"Content-Type": "application/json"},
  ));
}

final FlutterSecureStorage _storage = const FlutterSecureStorage();

// Store Token after login
Future<void> saveToken(String token) async {
  await _storage.write(key: "auth_token", value: token);
}

// Get saved token
Future<String?> getToken() async {
  return await _storage.read(key: "auth_token");
}

// 