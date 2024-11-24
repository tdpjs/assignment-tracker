import 'package:flutter/material.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';
import '../constants.dart';

final supabase = Supabase.instance.client;

class PasswordResetScreen extends StatelessWidget {
  const PasswordResetScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Uri? currentUri = Uri.tryParse(Uri.base.toString());
    final String? resetToken = currentUri?.queryParameters['code'];

    if (resetToken == null) {
      return Scaffold(
        appBar: appBar('Update Password'),
        body: const Center(
          child: Text('Invalid or missing reset token.'),
        ),
      );
    }
    return Scaffold(
      appBar: appBar('Update Password'),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            SupaResetPassword(
              accessToken: resetToken, // Use the token from the URL
              onSuccess: (response) {
                Navigator.of(context).pushReplacementNamed('/auth');
              },
            ),
            TextButton(
              child: const Text(
                'Take me back to Sign Up',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pushNamed(context, '/auth');
              },
            ),
          ],
        ),
      ),
    );
  }
}
