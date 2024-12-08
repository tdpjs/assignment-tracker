import 'package:flutter/material.dart';
import '../dialogs/show_cell_dialog.dart';
import 'package:flutter/gestures.dart';
import 'package:url_launcher/url_launcher.dart';
import '../utils/checkUrl.dart';

class ResourcesCell extends DataCell {
  ResourcesCell({
    required String name,
    required List<dynamic> resources,
    required BuildContext context,
  }) : super(
    resources.isNotEmpty
        ? GestureDetector(
      onLongPress: () => showResourcesDialog(
        context,
        'Resources',
        resources.whereType<String>().toList(),
      ),
      onDoubleTap: () => showResourcesDialog(
        context,
        'Resources',
        resources.whereType<String>().toList(),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 300, maxHeight: 120),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: resources
                .whereType<String>()
                .map<Widget>(
                  (resource) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: isValidUrl(resource)
                    ? RichText(
                  text: TextSpan(
                    text: resource,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () async {
                        final Uri uri = Uri.parse(resource);
                        if (await canLaunchUrl(uri)) {
                          await launchUrl(uri, mode: LaunchMode.externalApplication);
                        } else {
                          print('Could not launch $uri');
                        }
                      },
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )
                    : Text(
                  resource,
                  style: const TextStyle(
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            )
                .toList(),
          ),
        ),
      ),
    )
        : const SelectableText('-'),
  );
}



