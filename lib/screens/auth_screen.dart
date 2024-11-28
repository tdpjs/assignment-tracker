import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

final supabase = Supabase.instance.client;

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const SelectionArea(
            child: Text("Assignment Tracker")),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(24.0, 96.0, 24.0, 24.0),
        children: [
          Column(
            children: [
              const Text(
                'Please sign in to continue',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                ),
              ),
              const SizedBox(height: 24.0),
              SupaEmailAuth(
                redirectTo:
                kIsWeb ? null : "io.supabase.assignmenttracker://login-callback/",
                onSignInComplete: (res) => Navigator.pushNamed(context, '/home'),
                onSignUpComplete: (res) => Navigator.pushNamed(context, '/home'),
                onError: (error) => SnackBar(content: Text(error.toString())),
                resetPasswordRedirectTo: "http://localhost:3000/#/passwordreset",
              ),
              SupaSocialsAuth(
                socialProviders: const [
                  OAuthProvider.google,
                  OAuthProvider.github,
                  OAuthProvider.discord
                ],
                redirectUrl: "http://localhost:3000/#/home",
                // kIsWeb ? "https://thtoocplqnmszmmvyikb.supabase.co/auth/v1/callback"
                //         : "io.supabase.assignmenttracker://login-callback/",
                onSuccess: (session) => Navigator.pushReplacementNamed(context, '/home'),
                onError: (error) => SnackBar(
                  content: Text(
                    error.toString(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

