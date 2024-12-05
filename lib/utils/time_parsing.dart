import 'package:intl/intl.dart';
import '../constants.dart';

/// Converts a time string of format HH:MM:SS[+-]<timezone abbreviation>
/// to HH:MM TIMEZONE
/// @param [input] the timestamp in the format "HH:MM:SS [+-]<timezone abbreviation>"
/// @returns the time in the format "HH:MM TIMEZONE"
/// @returns "Invalid input format" if input string is not in the correct format
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

/// Fetch the timezone abbreviation corresponding to the given offset from UTC
/// @param [offset] the offset to use
/// @return the corresponding timezone abbreviation if there exist a mapping from the given offset
///         and 'Unknown' otherwise
String getTimezoneAbbreviation(String offset) {
  return timezoneOffsets[offset] ?? 'Unknown';
}

/// Converts a local time to its equivalent in UTC
/// @param [localTime] the localTime to be converted
/// @param [timezone] the timezone of the localTime
/// @throws ArgumentError if there isn't a mapping for the provided timezone
/// @returns the time equivalence of localTime in UTC
DateTime convertToUTC(DateTime localTime, String timezone) {

  if (!stringToIntoffsets.containsKey(timezone)) {
    throw ArgumentError('Invalid timezone: $timezone');
  }

  int offset = (stringToIntoffsets[timezone]! as num).toInt();

  return localTime.add(Duration(hours: offset));
}
