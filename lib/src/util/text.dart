/// Truncates [value] to at most [max] UTF-16 code units (the measure the
/// server and the SDK's length limits use), without leaving half of a
/// surrogate pair at the cut.
String truncateUtf16(String value, int max) {
  if (value.length <= max) return value;
  var end = max;
  if (end > 0) {
    final last = value.codeUnitAt(end - 1);
    if (last >= 0xD800 && last <= 0xDBFF) end--;
  }
  return value.substring(0, end);
}
