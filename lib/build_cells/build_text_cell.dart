import 'package:flutter/material.dart';
import 'package:assignment_tracker/functions/show_cell_dialog.dart'; // Import the dialog function from the other file

class TextCell extends StatelessWidget {
  final String? name;
  final String? content;
  final BuildContext context;

  const TextCell({
    Key? key,
    required this.context,
    this.name,
    this.content,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 200, maxHeight: 60),
      // Set max width and height
      child: GestureDetector(
        onDoubleTap: () =>
            showCellDialog(context, name ?? 'Cell Content', content ?? '-'),
        onLongPress: () =>
            showCellDialog(context, name ?? 'Cell Content', content ?? '-'),
        child: RichText(
          text: TextSpan(
            text: content,
            style: const TextStyle(color: Colors.black),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
