import 'package:flutter/material.dart';


/// Widget to display a welcome message of the current user
class WelcomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? displayName;

  const WelcomeAppBar({super.key, required this.displayName});

  @override
  WelcomeAppBarState createState() => WelcomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class WelcomeAppBarState extends State<WelcomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Welcome ${widget.displayName}'),
      centerTitle: true,
    );
  }
}

