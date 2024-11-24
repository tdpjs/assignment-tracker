import 'package:intl/intl.dart';
import '../constants.dart';

String convertToTimeZoneFormat(String input) {
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

String getTimezoneAbbreviation(String offset) {
  return timezoneOffsets[offset] ?? 'Unknown';
}