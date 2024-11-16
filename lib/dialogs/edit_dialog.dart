import 'package:flutter/material.dart';
import '../functions/table_management.dart';
import 'package:intl/intl.dart';
import '../constants.dart';
import '../home_screen.dart';

class EditDialog {
  static final _formKey = GlobalKey<FormState>();

  static void showEditAssignmentDialog({
    required BuildContext context,
    required VoidCallback initializeData,
    required Map<String, dynamic> data,
    required TextEditingController courseController,
    required TextEditingController nameController,
    required TextEditingController typeController,
    required TextEditingController dueDateController,
    required TextEditingController dueTimeController,
    required TextEditingController submissionController,
    required TextEditingController resourcesController,
  }) {
    courseController.text = data['Course'] ?? '';
    nameController.text = data['Name'] ?? '';
    typeController.text = data['Type'] ?? '';
    dueDateController.text = data['Due Date'] ?? '';
    dueTimeController.text = convertToTimeZoneFormat(data['Due Time'] ?? '');
    submissionController.text = data['Submission'] ?? '';
    resourcesController.text = data['Resources']?.join(', ') ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
          title: const Text('Edit Assignment'),
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
                    hintText: 'HH:MM TZ',
                  ),
                  validator: (value) {
                    final timeRegEx = RegExp(
                      r'^(0[0-9]|1[0-9]|2[0-3]):([0-5][0-9])\s?(AM|PM)?,?\s(IDLW|NST|HST|AKST|PST|MST|CST|EST|UTC|CET|EET|MSK|GST|PKT|BST|ICT|CST|JST|AEST|AEDT|NZST)$',
                    );
                    return (value == null || !timeRegEx.hasMatch(value))
                        ? 'Enter a valid time in HH:MM TZ format'
                        : null;
                  },
                ),
                TextFormField(
                  controller: submissionController,
                  decoration: const InputDecoration(
                    labelText: 'Submission URL',
                    hintText: 'Enter submission URL',
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
                  await editAssignment(
                    context: context,
                    initializeData: initializeData,
                    data: data,
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
              child: const Text('Edit Assignment'),
            ),
          ],
        );
      },
    );
  }
  static String convertToTimeZoneFormat(String input) {
    var regex = RegExp(r'(\d{2}):(\d{2}):(\d{2})([+-]\d{1,2})');
    var match = regex.firstMatch(input);

    if (match == null) {
      return 'Invalid input format';
    }

    String hour = match.group(1)!;
    String minute = match.group(2)!;
    String second = match.group(3)!;
    String timezoneOffset = match.group(4)!;

    // Combine the time string
    String timeString = '$hour:$minute:$second';
    DateTime time = DateFormat('HH:mm:ss').parse(timeString);

    // Convert to 12-hour format with AM/PM
    String formattedTime = DateFormat('hh:mm a').format(time);

    // Map the timezone offset to abbreviation
    String timezoneAbbreviation = getTimezoneAbbreviation(timezoneOffset);

    // Combine the formatted time and timezone abbreviation
    return '$formattedTime, $timezoneAbbreviation';
  }
  static String getTimezoneAbbreviation(String offset) {
    return timezoneOffsets[offset] ?? 'Unknown';
  }
}
