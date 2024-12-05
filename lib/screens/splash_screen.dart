import 'package:assignment_tracker/screens/home_screen.dart';
import 'package:flutter/material.dart';

import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'auth_screen.dart';

final activeSession = Supabase.instance.client.auth.currentSession;

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: AuthScreen()),//child: activeSession == null ? const AuthScreen() : const HomeScreen()
    );
  }
}