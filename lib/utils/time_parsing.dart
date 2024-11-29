import 'package:intl/intl.dart';
import '../constants.dart';


/// Converts a time string of format HH:MM:SS+/-<timezone abbreviation>
/// to HH:MM TIMEZONE
/// Returns "Invalid input format" if input string is not in the correct format
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

  String timeString = '$hour:$minute:$second';
  DateTime time = DateFormat('HH:mm:ss').parse(timeString);

  String formattedTime = DateFormat('hh:mm a').format(time);

  String timezoneAbbreviation = getTimezoneAbbreviation(timezoneOffset);

  return '$formattedTime, $timezoneAbbreviation';
}

String getTimezoneAbbreviation(String offset) {
  return timezoneOffsets[offset] ?? 'Unknown';
}