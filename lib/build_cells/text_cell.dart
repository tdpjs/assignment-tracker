import 'package:flutter/material.dart';
import 'package:assignment_tracker/dialogs/show_cell_dialog.dart'; // Import the dialog function from the other file

class TextCell extends DataCell {
  TextCell({
    required String name,
    required String content,
    required BuildContext context,
  }) : super(
    GestureDetector(
      onDoubleTap: () => showCellDialog(context, name, content),
      onLongPress: () => showCellDialog(context, name, content),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
        child: RichText(
          text: TextSpan(
            text: content,
            style: const TextStyle(color: Colors.black),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}

