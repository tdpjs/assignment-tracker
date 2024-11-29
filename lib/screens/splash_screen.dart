import 'package:assignment_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'auth_screen.dart';
final supabase = Supabase.instance.client;

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({super.key});
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   bool _isAuthenticated = false;
//
//   @override
//   void initState() {
//     super.initState();
//     _checkAuth();
//   }
//
//   Future<void> _checkAuth() async {
//     final activeSession = supabase.auth.currentSession;
//
//     if (activeSession != null) {
//       setState(() {
//         _isAuthenticated = true;
//       });
//     } else {
//       await _autoSignInForTesting();
//     }
//   }
//
//   Future<void> _autoSignInForTesting() async {
//     const email = '';
//     const password = '';
//
//     final response = await supabase.auth.signInWithPassword(
//       email: email,
//       password: password,
//     );
//     setState(() {
//       _isAuthenticated = true;
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (!_isAuthenticated) {
//       return const Scaffold(
//         body: Center(child: CircularProgressIndicator()),
//       );
//     }
//
//     return const Scaffold(
//       body: HomeScreen(),
//     );
//   }
// }

final activeSession = Supabase.instance.client.auth.currentSession;
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: activeSession == null ? const AuthScreen() : const HomeScreen()),
    );
  }
}