import 'package:flutter/material.dart';
  import '../utils/table_management.dart';

class AddDialog {
  static final _formKey = GlobalKey<FormState>();


  /// show the add assignment dialog
  static void showAddAssignmentDialog({
    required BuildContext context,
    required VoidCallback initializeData,
    required TextEditingController courseController,
    required TextEditingController nameController,
    required TextEditingController typeController,
    required TextEditingController dueDateController,
    required TextEditingController dueTimeController,
    required TextEditingController submissionController,
    required TextEditingController resourcesController,
  }) {
    courseController.clear();
    nameController.clear();
    typeController.clear();
    dueDateController.clear();
    dueTimeController.clear();
    submissionController.clear();
    resourcesController.clear();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Add Assignment'),
          content: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: courseController,
                  decoration: const InputDecoration(labelText: 'Course'),
                ),
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                  value == null || value.isEmpty ? 'Name is required' : null,
                ),
                TextFormField(
                  controller: typeController,
                  decoration: const InputDecoration(labelText: 'Type'),
                ),
                TextFormField(
                  controller: dueDateController,
                  decoration: const InputDecoration(
                    labelText: 'Due Date',
                    hintText: 'e.g. YYYY-MM-DD',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Due Date is required';
                    }
                    if (!RegExp(r'^\d{4}-\d{2}-\d{2}$').hasMatch(value)) {
                      return 'Enter a valid date (YYYY-MM-DD)';
                    }
                    return null;
                  },
                  onTap: () async {
                    FocusScope.of(context).requestFocus(FocusNode());
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      dueDateController.text =
                          pickedDate.toIso8601String().split('T').first;
                    }
                  },
                ),
                TextFormField(
                  controller: dueTimeController,
                  decoration: const InputDecoration(
                    labelText: 'Due Time',
                    hintText: 'HH:MM (TZ)',
                  ),
                  validator: (value) {
                    final timeRegEx = RegExp(
                      r'^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])\s?(AM|PM)?,?\s?(IDLW|NST|HST|AKST|PST|MST|CST|EST|UTC|CET|EET|MSK|GST|PKT|BST|ICT|CST|JST|AEST|AEDT|NZST)?$',
                    );
                    return (value == null || !timeRegEx.hasMatch(value))
                        ? 'Enter a valid time in HH:MM format, optionally with TZ'
                        : null;
                  },
                ),
                TextFormField(
                  controller: submissionController,
                  decoration: const InputDecoration(
                    labelText: 'Submission',
                    hintText: 'Enter submission location',
                  ),
                  keyboardType: TextInputType.url,
                ),
                TextFormField(
                  controller: resourcesController,
                  decoration: const InputDecoration(
                    labelText: 'Resources (comma-separated links)',
                    hintText: 'Enter resource links',
                  ),
                  maxLines: null,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  await addAssignment(
                    context: context,
                    initializeData: initializeData,
                    courseController: courseController,
                    nameController: nameController,
                    typeController: typeController,
                    dueDateController: dueDateController,
                    dueTimeController: dueTimeController,
                    submissionController: submissionController,
                    resourcesController: resourcesController,
                  );
                }
              },
              child: const Text('Add Assignment'),
            ),
          ],
        );
      },
    );
  }
}
