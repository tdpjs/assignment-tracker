import 'package:flutter/material.dart';

import '../dialogs/delete_dialog.dart';
import '../dialogs/edit_dialog.dart';
import '../build_cells/text_cell.dart';
import '../build_cells/resources_cell.dart';
import '../build_cells/link_cell.dart';
import '../build_cells/time_cell.dart';
import '../utils/time_parsing.dart';

/// Filters user's tasks based on provided filters
/// @param [currentData] the tasks to filter
/// @param [showOverdue] whether to display overdue tasks or not
/// @param [filters] the filters as entered by the user
/// @return a filtered list of tasks based on the criteria
List<Map<String, dynamic>> filterData({
  required List<Map<String, dynamic>> currentData,
  required bool showOverdue,
  required String? filters,
}) {
  String? courseFilter, nameFilter, typeFilter, timezoneFilter = 'PST'; // Default to PST
  DateTime? fromDate, toDate;

  if (filters != null && filters.isNotEmpty) {
    final filterSegments = filters.split(' ');
    for (var segment in filterSegments) {
      if (segment.startsWith('course:') && courseFilter == null) {
        courseFilter = segment.split(':')[1];
      } else if (segment.startsWith('name:') && nameFilter == null) {
        nameFilter = segment.split(':')[1];
      } else if (segment.startsWith('type:') && typeFilter == null) {
        typeFilter = segment.split(':')[1];
      } else if (segment.startsWith('timezone:') && timezoneFilter == null) {
        timezoneFilter = segment.split(':')[1];
      } else if (segment.startsWith('from:') && fromDate == null) {
        try {
          fromDate = DateTime.parse(segment.split(':')[1]);
        } catch (e) {
          throw ArgumentError("Invalid from date format (YYYY-MM-DD)");
        }
      } else if (segment.startsWith('to:') && toDate == null) {
        try {
          toDate = DateTime.parse(segment.split(':')[1]);
        } catch (e) {
          throw ArgumentError("Invalid to date format (YYYY-MM-DD)");
        }
      }
    }
  }

  // If timezoneFilter is null, default to 'PST'
  timezoneFilter ??= 'PST';

  final fromDateUTC = fromDate != null ? convertToUTC(fromDate, timezoneFilter) : null;
  final toDateUTC = toDate != null ? convertToUTC(toDate, timezoneFilter) : null;

  final currentUTC = DateTime.now().toUtc();

  return currentData.where((data) {
    if (courseFilter != null && !data['Course'].contains(courseFilter)) return false;

    if (nameFilter != null && !data['Name'].contains(nameFilter)) return false;

    if (typeFilter != null && !data['Type'].contains(typeFilter)) return false;

    final dueDate = DateTime.parse(data['Due Date']);
    final dueDateUTC = convertToUTC(dueDate, timezoneFilter!);

    if (fromDateUTC != null && dueDateUTC.isBefore(fromDateUTC)) return false;

    if (toDateUTC != null && dueDateUTC.isAfter(toDateUTC)) return false;

    if (!showOverdue && dueDateUTC.isBefore(currentUTC)) return false;

    return true;
  }).toList();
}


