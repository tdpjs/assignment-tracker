import 'package:assignment_tracker/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'auth_screen.dart';
import 'home_screen.dart';


void main() async {
  await dotenv.load(fileName: ".env");
  await Supabase.initialize(
      url: dotenv.env['SUPABASE_URL']!,
      anonKey: dotenv.env['SUPABASE_ANON_KEY']!);
  runApp(
    const MyApp(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Supabase Auth UI',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.dark,
          primary: Color.fromARGB(255, 0, 0, 0),
          onPrimary: Color.fromARGB(255, 235, 235, 235),
          primaryContainer: Color.fromARGB(255, 25, 26, 24),
          onPrimaryContainer: Color.fromARGB(255, 235, 235, 235),
          primaryFixed: Color.fromARGB(255, 55, 55, 55),
          onPrimaryFixed: Color.fromARGB(255, 225, 225, 225),
          secondary: Color.fromARGB(255, 45, 46, 44),
          onSecondary: Color.fromARGB(255, 235, 235, 235),
          error: Color.fromARGB(255, 245, 29, 47),
          onError: Color.fromARGB(255, 235, 235, 235),
          errorContainer: Color.fromARGB(255, 245, 174, 180),
          surface: Color.fromARGB(255, 235, 235, 235),
          onSurface: Color.fromARGB(255, 0, 0, 0)),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}
