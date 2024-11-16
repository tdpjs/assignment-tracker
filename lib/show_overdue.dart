import 'package:flutter/material.dart';
import 'dart:async';

bool showOverdue = false;

class ShowOverdueCheckbox extends StatefulWidget {
  final Future<void> Function() applyFilters; // Correct type

  const ShowOverdueCheckbox({Key? key, required this.applyFilters})
      : super(key: key);

  @override
  ShowOverdueCheckboxState createState() => ShowOverdueCheckboxState();
}

class ShowOverdueCheckboxState extends State<ShowOverdueCheckbox> {
  Timer? _debounce;

  void _onCheckboxChanged(bool? value) {
    if (value != null) {
      setState(() {
        showOverdue = value; // Update global variable
      });

      // Cancel any ongoing debounce timer
      _debounce?.cancel();

      // Start a new debounce timer
      _debounce = Timer(const Duration(milliseconds: 300), () {
        widget.applyFilters(); // Apply filters after debounce
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Checkbox(
          value: showOverdue,
          onChanged: _onCheckboxChanged,
        ),
        const Text('Show Overdue Tasks'),
      ],
    );
  }
}

