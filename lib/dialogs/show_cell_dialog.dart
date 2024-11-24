import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure to import url_launcher
import 'package:flutter/gestures.dart';

void showCellDialog(BuildContext context, String column, String content) {
  String? urlString = content.toString();
  if (Uri.tryParse(urlString)?.hasAbsolutePath == true) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(column),
        content: SingleChildScrollView(
          child: RichText(
            text: TextSpan(
              text: urlString,
              style: const TextStyle(color: Colors.blue),
              recognizer: TapGestureRecognizer()
                ..onTap = () async {
                  final Uri uri = Uri.parse(urlString);
                  if (await canLaunchUrl(uri)) {
                    await launchUrl(uri);
                  } else {
                    print('Could not launch $uri');
                  }
                },
            ),
            maxLines: 1, // Limit text to one line
            overflow: TextOverflow.ellipsis, // Handle overflow
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  } else {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(column),
        content: SingleChildScrollView(
          child: Text(content),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

void showResourcesDialog(BuildContext context, String column, List<dynamic> content) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text(column),  // The name at the top of the dialog
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: content.map((urlString) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    text: urlString,
                    style: const TextStyle(color: Colors.blue),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse(urlString);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          print('Could not launch $uri');
                        }
                      },
                  ),
                  maxLines: 1, // Limit text to one line
                  overflow: TextOverflow.ellipsis, // Handle overflow
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      );
    },
  );
}