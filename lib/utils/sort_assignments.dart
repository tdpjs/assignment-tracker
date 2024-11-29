import 'package:assignment_tracker/utils/time_parsing.dart';

/// Sorts the displayed tasks based on a criteria
/// @param [currentData] the tasks to filter
/// @param [criteria] the criteria to sort by
List<Map<String, dynamic>> sortData({
  required List<Map<String, dynamic>> currentData,
  required String? criteria,
}) {
  List<Map<String, dynamic>> sortedData = List.from(currentData);

  sortedData.sort((a, b) {
    DateTime dateTimeA = _combineDateAndTime(a["Due Date"], a["Due Time"]);
    DateTime dateTimeB = _combineDateAndTime(b["Due Date"], b["Due Time"]);

    switch (criteria) {
      case "due_date":
        return dateTimeA.compareTo(dateTimeB);

      case "due_date_descending":
        return dateTimeB.compareTo(dateTimeA);

      case "order_added":
        return a["id"].compareTo(b["id"]);

      case "order_added_descending":
        return b["id"].compareTo(a["id"]);

      default:
        return 0;
    }
  });

  return sortedData;
}

/// Combines the "Due Date" and "Due Time" into a single DateTime object.
DateTime _combineDateAndTime(String dueDate, String dueTime) {
  try {
    DateTime date = DateTime.parse(dueDate);

    final timeRegex = RegExp(r'^(\d{2}):(\d{2}):(\d{2})([+-]\d+)$');
    final match = timeRegex.firstMatch(dueTime);
    if (match == null) {
      throw ArgumentError("Invalid time format: $dueTime");
    }

    int hour = int.parse(match.group(1)!);
    int minute = int.parse(match.group(2)!);
    int second = int.parse(match.group(3)!);
    String offset = match.group(4)!;

    DateTime localDateTime = DateTime(date.year, date.month, date.day, hour, minute, second);
    return convertToUTC(localDateTime, getTimezoneAbbreviation(offset));
  } catch (e) {
    throw ArgumentError("Invalid date or time format: $dueDate, $dueTime");
  }
}
