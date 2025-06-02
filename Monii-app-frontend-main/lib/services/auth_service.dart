import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:monii/config/session_manager.dart';
import 'package:monii/config/api_config.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<bool> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        print("❌ User canceled the login");
        return false;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final UserCredential authResult =
          await _auth.signInWithCredential(credential);

      final User? user = authResult.user;
      final String? idToken = await user?.getIdToken();

      print("✅ Firebase ID Token: $idToken");

      if (idToken == null) {
        throw Exception("Google ID Token is null after Firebase login");
      }

      await sendTokenToBackend(idToken);
    } catch (e) {
      print("❌ Google Sign-In Error: $e");
      return false;
    }
    return true;
  }

  Future<void> sendTokenToBackend(String idToken) async {
    final response = await http.post(
      Uri.parse('http://10.0.2.2:8080/auth/google-login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"idToken": idToken}),
    );

    if (response.statusCode == 200) {
      await SessionManager.saveToken(response.body);
      print("User authenticated with backend successfully");
    } else {
      print("Failed to authenticate: ${response.body}");
    }
  }

  // Register
  static Future<bool> registerUser(String fullName, String email, String password) async {
    final response = await http.post(
      Uri.parse("http://10.0.2.2:8080/auth/register"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullName": fullName,
        "email" : email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  // Login
  static Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse("${ApiConfig.baseUrl}${ApiConfig.loginEndpoint}"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": email,
        "password": password
      }),
    );

    if (response.statusCode == 200) {
      // Directly save the JWT token from the response body
      await SessionManager.saveToken(response.body);
      return true;
    } else {
      return false;
    }
  }
  
}
