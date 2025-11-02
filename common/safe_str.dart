// lib/common/utils/safe_str.dart
extension SafeStringX on String? {
  /// Sicherer Prefix: schneidet bis [max] Zeichen, ohne RangeError.
  String safePrefix(int max, {String empty = '—'}) {
    final s = this ?? '';
    if (s.isEmpty) return empty;
    final end = s.length < max ? s.length : max;
    return s.substring(0, end);
  }

  /// Sicherer Suffix (falls du irgendwo "letzte X Zeichen" brauchst)
  String safeSuffix(int max, {String empty = '—'}) {
    final s = this ?? '';
    if (s.isEmpty) return empty;
    final start = s.length <= max ? 0 : s.length - max;
    return s.substring(start);
  }
}
