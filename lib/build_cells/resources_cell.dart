import 'package:flutter/material.dart';
import '../dialogs/show_cell_dialog.dart';
import 'link_cell.dart';

class ResourcesCell extends DataCell {
  ResourcesCell({
    required String name,
    required List<dynamic> resources,
    required BuildContext context,
  }) : super( (resources.isNotEmpty) ?
      GestureDetector(
        onLongPress: () => showResourcesDialog(context, 'Resources', resources.whereType<String>().toList()),
        onDoubleTap: () => showResourcesDialog(context, 'Resources', resources.whereType<String>().toList()),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 300, maxHeight: 120),
          child: SingleChildScrollView(
            child: Column(
              children: resources
                  .whereType<String>()
                  .map<Widget>((resource) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 2.0),
                child: GestureDetector(
                  onLongPress: () => showResourcesDialog(
                      context, 'Resources', [resource]),
                  onDoubleTap: () => showResourcesDialog(
                      context, 'Resources', [resource]),
                  child: Text(
                    resource,
                    style: const TextStyle(
                      color: Colors.blue,
                      decoration: TextDecoration.underline,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ))
                  .toList(),
            ),
          ),
        ),
      ) : const SelectableText('-')
  );
}



