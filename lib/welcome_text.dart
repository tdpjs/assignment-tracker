import 'package:flutter/material.dart';

class WelcomeAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String? displayName;

  const WelcomeAppBar({Key? key, required this.displayName}) : super(key: key);

  @override
  _WelcomeAppBarState createState() => _WelcomeAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _WelcomeAppBarState extends State<WelcomeAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text('Welcome ${widget.displayName}'),
      centerTitle: true,
    );
  }
}

