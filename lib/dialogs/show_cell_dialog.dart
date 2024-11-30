import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Make sure to import url_launcher
import 'package:flutter/gestures.dart';

/// Displays the content of a cell
/// @param [context] the current BuildContext of the app
/// @param [column] the name of the column of the cell
/// @param [content] the content of the cell
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


/// Displays the content of a resources cell
/// @param [context] the current BuildContext of the app
/// @param [column] the name of the column of the cell
/// @param [content] the content of the cell
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
              // Check if the string is a valid URL
              String? url = urlString.toString();
              bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath == true;

              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: RichText(
                  text: TextSpan(
                    text: url,
                    style: TextStyle(
                      color: isValidUrl ? Colors.blue : Colors.black, // Blue if URL, black otherwise
                    ),
                    recognizer: isValidUrl
                        ? (TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse(url);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri);
                        } else {
                          print('Could not launch $uri');
                        }
                      })
                        : null, // No gesture recognizer if it's not a URL
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
