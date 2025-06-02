import 'package:flutter/material.dart';
import 'package:monii/services/auth_service.dart';
import 'package:monii/views/auth/register_screen.dart';
import 'package:monii/views/home/home_screen.dart';
import 'package:monii/views/home/starter_screen.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _authService = AuthService();

  void handleLogin() async {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    bool success = await AuthService.login(email, password);
    if (success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Login failed!")));
    }
  }

  void handleLoginWithGoogle() async {
    bool success = await _authService.signInWithGoogle();
    if (success) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Google login failed!")));
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: emailController, decoration: InputDecoration(labelText: "Email")),
            TextField(controller: passwordController, decoration: InputDecoration(labelText: "Password"), obscureText: true),
            SizedBox(height: 20),
            ElevatedButton(onPressed: handleLogin, child: Text("Login")),
            SizedBox(height: 10),
            ElevatedButton.icon(
              onPressed: handleLoginWithGoogle,
              icon: Icon(Icons.login),
              label: Text("Login with Google"),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => RegisterScreen()),
                );
              },
              child: Text("Don't have an account? Register here!"),
            ),
          ],
        ),
      ),
    );
  }
}