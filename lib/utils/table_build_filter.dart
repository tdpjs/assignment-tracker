// Import necessary packages
import 'package:flutter/material.dart';

import '../dialogs/delete_dialog.dart';
import '../dialogs/edit_dialog.dart';
import '../build_cells/text_cell.dart';
import '../build_cells/resources_cell.dart';
import '../build_cells/link_cell.dart';
import '../build_cells/time_cell.dart';

/// Function to convert local time to UTC using the given timezone offset.
DateTime convertToUTC(DateTime localTime, String timezone, Map<String, int> stringToIntOffsets) {
  // If the timezone is not found, throw an error.
  if (!stringToIntOffsets.containsKey(timezone)) {
    throw ArgumentError('Invalid timezone: $timezone');
  }

  // Get the timezone offset.
  int offset = stringToIntOffsets[timezone]!;

  // Convert the local time to UTC by adding/subtracting the offset
  return localTime.add(Duration(hours: offset));
}

/// Function to filter data based on various criteria.
List<Map<String, dynamic>> filterData({
  required List<Map<String, dynamic>> userData,
  String? course,
  String? name,
  String? type,
  String? timezone,
  DateTime? fromDate,
  DateTime? toDate,
  required bool showOverdue,
  required Map<String, int> stringToIntOffsets,
}) {
  if ([course, name, type, timezone, fromDate, toDate].every((filter) => filter == null) && showOverdue) {
    return userData; // Return all data if no filters are provided
  }

  // Convert fromDate and toDate to UTC once.
  final fromDateUTC = fromDate != null && timezone != null
      ? convertToUTC(fromDate, timezone, stringToIntOffsets)
      : null;
  final toDateUTC = toDate != null && timezone != null
      ? convertToUTC(toDate, timezone, stringToIntOffsets)
      : null;

  // Get the current UTC time.
  final currentUTC = DateTime.now().toUtc();

  return userData.where((data) {
    // Filter by course.
    if (course != null && data['Course'] != course) return false;

    // Filter by name (partial match).
    if (name != null && !data['Name'].contains(name)) return false;

    // Filter by type.
    if (type != null && data['Type'] != type) return false;

    // Parse the due date and time.
    final dueDate = DateTime.parse(data['Due Date']);
    final dueDateUTC = timezone != null ? convertToUTC(dueDate, timezone, stringToIntOffsets) : dueDate.toUtc();

    // Filter by fromDate and toDate.
    if (fromDateUTC != null && dueDateUTC.isBefore(fromDateUTC)) return false;
    if (toDateUTC != null && dueDateUTC.isAfter(toDateUTC)) return false;

    // If showOverdue is false, filter out overdue tasks.
    if (!showOverdue && dueDateUTC.isBefore(currentUTC)) return false;

    return true;
  }).toList();
}

/// Function to build a filtered DataTable based on the given filters and data.
Future<DataTable> buildFilteredDataTable({
  required List<Map<String, dynamic>> userData,
  required String? filters,
  required Map<String, int> stringToIntOffsets,
  required bool showOverdue,
}) async {
  // Initialize filter parameters.
  String? courseFilter, nameFilter, typeFilter, timezoneFilter;
  DateTime? fromDate, toDate;

  // Parse the filters string if provided.
  if (filters != null && filters.isNotEmpty) {
    final filterSegments = filters.split(' ');
    for (var segment in filterSegments) {
      if (segment.startsWith('course:')) {
        courseFilter = segment.split(':')[1];
      } else if (segment.startsWith('name:')) {
        nameFilter = segment.split(':')[1];
      } else if (segment.startsWith('type:')) {
        typeFilter = segment.split(':')[1];
      } else if (segment.startsWith('timezone:')) {
        timezoneFilter = segment.split(':')[1];
      } else if (segment.startsWith('from:')) {
        fromDate = DateTime.parse(segment.split(':')[1]);
      } else if (segment.startsWith('to:')) {
        toDate = DateTime.parse(segment.split(':')[1]);
      }
    }
  }

  if (fromDate != null || toDate != null) {
    if (timezoneFilter == null || timezoneFilter.isEmpty) {
      throw ArgumentError(
          'A timezone must be provided when using from and to.');
    }
  }

  // Fetch filtered data from the filterData function.
  final filteredData = filterData(
    userData: userData,
    course: courseFilter,
    name: nameFilter,
    type: typeFilter,
    timezone: timezoneFilter,
    fromDate: fromDate,
    toDate: toDate,
    showOverdue: showOverdue,
    stringToIntOffsets: stringToIntOffsets,
  );

  // Build the DataTable rows from the filtered data.
  return DataTable(
    columns: const [
      DataColumn(label: SelectableText('Course')),
      DataColumn(label: SelectableText('Name')),
      DataColumn(label: SelectableText('Type')),
      DataColumn(label: SelectableText('Due Date')),
      DataColumn(label: SelectableText('Due Time')),
      DataColumn(label: SelectableText('Submission')),
      DataColumn(label: SelectableText('Resources')),
      DataColumn(label: SelectableText('Actions')),
    ],
    rows: filteredData
        .map(
          (data) => DataRow(
        cells: [
          DataCell(buildCell("Course", data['Course'])),
          DataCell(buildCell("Name", data['Name'])),
          DataCell(buildCell("Type", data['Type'])),
          DataCell(buildCell("Due Date", data['Due Date'])),
          DataCell(_buildTimeCell(data['Due Time'], name: "Due Time")),
          DataCell(_buildLinkCell(data['Submission'])),
          DataCell(_buildResourcesCell(data['Resources'] ?? [])),
          DataCell(
            Row(
              children: [
                IconButton(
                  onPressed: () => EditDialog.showEditAssignmentDialog(
                    context: context,
                    initializeData: _initializeData,
                    data: data,
                    courseController: courseController,
                    nameController: nameController,
                    typeController: typeController,
                    dueDateController: dueDateController,
                    dueTimeController: dueTimeController,
                    submissionController: submissionController,
                    resourcesController: resourcesController,
                  ),
                  icon: const Icon(Icons.edit),
                ),
                IconButton(
                  onPressed: () => DeleteDialog.showDeleteConfirmationDialog(
                      context: context,
                      initializeData: _initializeData,
                      data: data
                  ),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          ),
        ],
      ),
    )
        .toList(),
  );
}
