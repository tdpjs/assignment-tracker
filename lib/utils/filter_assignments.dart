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
  String? courseFilter, nameFilter, typeFilter, timezoneFilter;
  DateTime? fromDate, toDate;

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
  if ([courseFilter, nameFilter, typeFilter, fromDate, toDate].every((filter) => filter == null) && showOverdue) {
    return currentData;
  }

  final fromDateUTC = fromDate != null && timezoneFilter != null
      ? convertToUTC(fromDate, timezoneFilter)
      : null;
  final toDateUTC = toDate != null && timezoneFilter != null
      ? convertToUTC(toDate, timezoneFilter)
      : null;

  final currentUTC = DateTime.now().toUtc();

  return currentData.where((data) {
    if (courseFilter != null && !data['Course'].contains(courseFilter)) return false;

    if (nameFilter != null && !data['Name'].contains(nameFilter)) return false;

    if (typeFilter != null && !data['Type'].contains(typeFilter)) return false;

    final dueDate = DateTime.parse(data['Due Date']);
    final dueDateUTC = timezoneFilter != null ? convertToUTC(dueDate, timezoneFilter) : dueDate.toUtc();

    if (fromDateUTC != null && dueDateUTC.isBefore(fromDateUTC)) return false;

    if (toDateUTC != null && dueDateUTC.isAfter(toDateUTC)) return false;

    if (!showOverdue && dueDateUTC.isBefore(currentUTC)) return false;

    return true;
  }).toList();
}


