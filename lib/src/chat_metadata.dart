import 'package:flutter/foundation.dart';

/// The most entries a chat message's `metadata` may hold.
const int chatMetadataMaxEntries = 20;

/// The longest metadata key, after trimming (UTF-16 code units).
const int chatMetadataKeyMax = 64;

/// The longest metadata value; longer values are truncated (UTF-16 code
/// units — the same measure the server and the message-body limit use).
const int chatMetadataValueMax = 500;

/// The metadata to send with a chat message: [global] (from
/// `Featurely.setChatMetadata`) merged with [local] (passed to
/// `Featurely.showChat`), [local] winning on a key collision.
///
/// Both maps are cleaned first, mirroring the server's rules so a send is
/// never rejected over metadata: keys are trimmed, entries with a blank key,
/// a blank value, or a key longer than [chatMetadataKeyMax] are dropped,
/// values are trimmed and truncated to [chatMetadataValueMax], and at most
/// [chatMetadataMaxEntries] entries are kept (the first ones by sorted key).
/// Returns null when nothing is left, so the field is omitted. Never throws;
/// dropped input is reported with `debugPrint` in debug builds.
Map<String, String>? effectiveChatMetadata(
  Map<String, String>? global,
  Map<String, String>? local,
) {
  final merged = <String, String>{
    ..._clean(global),
    ..._clean(local),
  };
  if (merged.isEmpty) return null;
  final keys = merged.keys.toList()..sort();
  if (keys.length > chatMetadataMaxEntries) {
    _debugLog('only the first $chatMetadataMaxEntries of ${keys.length} '
        'entries (by sorted key) are sent; dropped: '
        '${keys.sublist(chatMetadataMaxEntries).join(', ')}');
  }
  return Map.unmodifiable({
    for (final key in keys.take(chatMetadataMaxEntries)) key: merged[key]!,
  });
}

/// Trims and validates one map's entries (no entry cap). Iterates in sorted
/// key order so keys that collide after trimming resolve deterministically.
Map<String, String> _clean(Map<String, String>? metadata) {
  if (metadata == null || metadata.isEmpty) return const {};
  final result = <String, String>{};
  final rawKeys = metadata.keys.toList()..sort();
  for (final rawKey in rawKeys) {
    final key = rawKey.trim();
    if (key.isEmpty) {
      _debugLog('dropped an entry with a blank key');
      continue;
    }
    if (key.length > chatMetadataKeyMax) {
      _debugLog('dropped key "$key": longer than $chatMetadataKeyMax '
          'characters');
      continue;
    }
    final value = _truncate(metadata[rawKey]!.trim());
    if (value.isEmpty) continue; // The server drops blank values too.
    result[key] = value;
  }
  return result;
}

String _truncate(String value) {
  if (value.length <= chatMetadataValueMax) return value;
  var end = chatMetadataValueMax;
  // Don't leave half of a surrogate pair at the cut.
  final last = value.codeUnitAt(end - 1);
  if (last >= 0xD800 && last <= 0xDBFF) end--;
  return value.substring(0, end);
}

void _debugLog(String message) {
  if (kDebugMode) debugPrint('Featurely chat metadata: $message');
}
