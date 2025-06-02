import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:monii/config/session_manager.dart';
import 'package:monii/views/home/account_screen.dart';
import 'package:monii/views/home/category_detail_screen.dart';
import 'package:monii/views/home/chat_screen.dart';
import 'package:monii/views/home/home_screen.dart';
import 'package:monii/views/auth/register_screen.dart';
import 'package:monii/views/auth/login_screen.dart';
import 'package:monii/views/home/add_transaction_screen.dart';
import 'package:monii/views/home/add_category_screen.dart';
import 'package:monii/views/home/add_budget_screen.dart';
import 'package:monii/views/home/starter_screen.dart';
import 'package:monii/views/home/transaction_detail_screen.dart';
import 'package:monii/views/reports/reports_screen.dart';
import 'package:monii/views/reports/income_screen.dart';
import 'package:monii/views/reports/expenditure_screen.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appTitle = 'Monii App';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _appTitle,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en', ''),
        Locale('vi', ''),
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashWrapper(),
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/starter': (context) => StarterScreen(),
        '/home': (context) => HomeScreen(),
        '/add-transaction': (context) => AddTransactionScreen(),
        '/add-category': (context) => AddCategoryScreen(),
        '/add-budget': (context) => AddBudgetScreen(),
        '/reports': (context) => ReportsScreen(),
        '/income': (context) => IncomeScreen(),
        '/expenditure': (context) => ExpenditureScreen(),
        '/category-detail' : (context) => CategoryDetailScreen(),
        '/transaction-detail' : (context) => TransactionDetailScreen(),
        '/chat': (context) => ChatScreen(),
        '/account_screen': (context) => AccountScreen(),
      },
    );
  }
}

class SplashWrapper extends StatefulWidget {
  const SplashWrapper({super.key});

  @override
  State<SplashWrapper> createState() => _SplashWrapperState();
}

class _SplashWrapperState extends State<SplashWrapper> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndRedirect();
  }

  void _checkAuthAndRedirect() async {
    final token = await SessionManager.getToken();
    if (token == null) {
      Navigator.pushReplacementNamed(context, '/login');
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('https://your-api-url.com/validate-token'),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response.statusCode == 200) {
        final setupDone = await SessionManager.isSetupComplete();
        if (setupDone) {
          Navigator.pushReplacementNamed(context, '/home');
        } else {
          Navigator.pushReplacementNamed(context, '/starter');
        }
      } else {
        await SessionManager.clearSession();
        Navigator.pushReplacementNamed(context, '/login');
      }
    } catch (e) {
      debugPrint('Token validation error: $e');
      await SessionManager.clearSession();
      Navigator.pushReplacementNamed(context, '/login');
    }
  }


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
