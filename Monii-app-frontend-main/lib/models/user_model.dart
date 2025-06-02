import 'dart:convert';

class User {
  String id;
  String fullName;
  String email;
  String? password; // Nullable, used for email login
  String? googleId; // Nullable, used for Google login
  String? avatarUrl;
  String language;
  String currency;
  DateTime createdAt;
  DateTime updatedAt;

  User({
    required this.id,
    required this.fullName,
    required this.email,
    this.password,
    this.googleId,
    this.avatarUrl,
    required this.language,
    required this.currency,
    required this.createdAt,
    required this.updatedAt,
  });

  // Convert JSON to User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      fullName: json['fullName'],
      email: json['email'],
      password: json['password'],
      googleId: json['googleId'],
      avatarUrl: json['avatarUrl'],
      language: json['language'] ?? "en",
      currency: json['currency'] ?? "USD",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  // Convert User to JSON
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "fullName": fullName,
      "email": email,
      "password": password,
      "googleId": googleId,
      "avatarUrl": avatarUrl,
      "language": language,
      "currency": currency,
      "createdAt": createdAt.toIso8601String(),
      "updatedAt": updatedAt.toIso8601String(),
    };
  }

  // Convert from JSON string
  static User fromJsonString(String jsonString) {
    return User.fromJson(jsonDecode(jsonString));
  }

  // Convert to JSON string
  String toJsonString() {
    return jsonEncode(toJson());
  }
}
