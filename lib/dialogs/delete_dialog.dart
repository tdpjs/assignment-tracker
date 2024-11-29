import 'package:flutter/material.dart';
import '../utils/table_management.dart';

class DeleteDialog {
  static void showDeleteConfirmationDialog({
    required BuildContext context,
    required VoidCallback initializeData,
    required Map<String, dynamic> data
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Delete Assignment'),
          content: const Text('Are you sure you want to delete this assignment?'),
          actions: [
            TextButton(
              key: const Key('cancelButton'),
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              key: const Key('deleteButton'),
              onPressed: () async {
                await deleteAssignment(
                  context: context,
                  initializeData: initializeData,
                  data: data
                );
              },
              child: const Text('Delete Assignment'),
            ),
          ],
        );
      },
    );
  }
}
