import 'package:flutter/material.dart';
import 'dart:async';

bool showOverdue = false;

/// Widget to implement the feature of showing/hiding tasks whose due dates and time are overdue
/// When the checkbox is checked, all of the user's tasks will be displayed in the table
/// When the checkbox is unchecked only tasks whose due dates and times have not passed will be displayed
/// By default the option is unchecked, hiding all overdue tasks.
class ShowOverdueCheckbox extends StatefulWidget {
  final Future<void> Function() applyFilters;

  const ShowOverdueCheckbox({super.key, required this.applyFilters});

  @override
  ShowOverdueCheckboxState createState() => ShowOverdueCheckboxState();
}

class ShowOverdueCheckboxState extends State<ShowOverdueCheckbox> {
  Timer? _debounce;

  void _onCheckboxChanged(bool? value) {
    if (value != null) {
      setState(() {
        showOverdue = value;
      });

      _debounce?.cancel();

      _debounce = Timer(const Duration(milliseconds: 300), () {
        widget.applyFilters();
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

