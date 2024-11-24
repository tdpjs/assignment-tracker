import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:assignment_tracker/dialogs/show_cell_dialog.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkCell extends DataCell {
  LinkCell({
    required String name,
    required String url,
    required BuildContext context
  }) : super(
      Uri.tryParse(url)!.hasAbsolutePath
          ? GestureDetector(
        onLongPress: () => showCellDialog(context, name, url),
        onDoubleTap: () => showCellDialog(context, name, url),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: RichText(
            text: TextSpan(
              text: url,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri uri = Uri.parse(url);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    print('Could not launch $uri');
                  }
                },
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ) : GestureDetector(
        onLongPress: () => showCellDialog(context, name, url),
        onDoubleTap: () => showCellDialog(context, name, url),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300),
          child: Text(url),
        ),
      )
  );
}