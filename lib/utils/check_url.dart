/// Checks if a string is a valid url
/// @param [url] the string to check
/// @return true if the string is a valid url and false otherwise
bool isValidUrl(String url) {
  final Uri? uri = Uri.tryParse(url);
  if (uri == null) return false;
  return uri.hasScheme && (uri.scheme == 'http' || uri.scheme == 'https');
}