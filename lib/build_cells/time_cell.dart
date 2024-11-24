import 'package:flutter/material.dart';
import 'package:assignment_tracker/dialogs/show_cell_dialog.dart';
import '../utils/time_parsing.dart';

class TimeCell extends DataCell {
  TimeCell({
    required String time,
    required BuildContext context,
    required String name,
  }) : super(
      GestureDetector(
        onLongPress: () => showCellDialog(context, name, convertToTimeZoneFormat(time)),
        onDoubleTap: () => showCellDialog(context, name, convertToTimeZoneFormat(time)),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(
            time ?? 'No time provided',
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ),
  );
}



