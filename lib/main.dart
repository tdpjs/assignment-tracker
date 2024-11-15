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
      theme: customTheme(),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/auth': (context) => const AuthScreen(),
        '/home': (context) => const HomeScreen(),
      },
    );
  }
}


ThemeData customTheme() {
  return ThemeData.from(
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color.fromARGB(255, 40, 40, 40),
      onPrimary: Color.fromARGB(255, 235, 235, 235),
      primaryContainer: Color.fromARGB(255, 25, 26, 24),
      onPrimaryContainer: Color.fromARGB(255, 235, 235, 235),
      primaryFixed: Color.fromARGB(255, 55, 55, 55),
      onPrimaryFixed: Color.fromARGB(255, 225, 225, 225),
      secondary: Color.fromARGB(255, 45, 46, 44),
      onSecondary: Color.fromARGB(255, 235, 235, 235),
      error: Color.fromARGB(255, 245, 29, 47),
      onError: Color.fromARGB(255, 239, 110, 110),
      errorContainer: Color.fromARGB(255, 245, 174, 180),
      surface: Color.fromARGB(255, 235, 235, 235),
      onSurface: Color.fromARGB(255, 20, 20, 20),
      tertiary: Color.fromARGB(255, 235, 235, 235),
      onTertiary: Color.fromARGB(255, 40, 40, 40),
    ),
    textTheme: const TextTheme(
      displayLarge: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 57, fontWeight: FontWeight.bold),
      displayMedium: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 45, fontWeight: FontWeight.bold),
      displaySmall: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 36, fontWeight: FontWeight.bold),
      headlineLarge: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 32, fontWeight: FontWeight.bold),
      headlineMedium: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 28, fontWeight: FontWeight.w600),
      headlineSmall: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 24, fontWeight: FontWeight.w600),
      titleLarge: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 22, fontWeight: FontWeight.w600),
      titleMedium: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 20, fontWeight: FontWeight.w500),
      titleSmall: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 18, fontWeight: FontWeight.w500),
      bodyLarge: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 16, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 14, fontWeight: FontWeight.normal),
      bodySmall: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 12, fontWeight: FontWeight.normal),
      labelLarge: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 16, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 14, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(color: Color.fromARGB(255, 20, 20, 20), fontSize: 12, fontWeight: FontWeight.bold),
    ),
  );

