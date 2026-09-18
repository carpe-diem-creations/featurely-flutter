import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';

/// The host app's diagnostics provider (see
/// `Featurely.setChatDiagnosticsProvider`).
typedef ChatDiagnosticsProvider = Future<Map<String, Object?>?> Function();

/// The largest diagnostics snapshot, in UTF-8 bytes of its compact JSON.
const int chatDiagnosticsMaxBytes = 4096;

/// The deepest nesting allowed; the top-level object counts as level 1.
const int chatDiagnosticsMaxDepth = 3;

/// The longest string value (UTF-16 code units).
const int chatDiagnosticsStringMax = 200;

/// The most items an array may hold.
const int chatDiagnosticsArrayMax = 30;

/// How long a send waits for the provider.
const Duration chatDiagnosticsTimeout = Duration(seconds: 1);

/// Runs [provider] for one message send and returns its validated result,
/// or null when the message should go without diagnostics: no provider, a
/// null or empty result, a throw, no answer within [timeout], or output that
/// breaks the limits (see [validChatDiagnostics]). Never throws; every
/// dropped snapshot is reported with `debugPrint` in debug builds only.
Future<Map<String, Object?>?> collectChatDiagnostics(
  ChatDiagnosticsProvider? provider, {
  Duration timeout = chatDiagnosticsTimeout,
}) async {
  if (provider == null) return null;
  final Map<String, Object?>? raw;
  try {
    raw = await Future.sync(provider).timeout(timeout);
  } on TimeoutException {
    _debugLog('the provider took longer than ${timeout.inMilliseconds} ms; '
        'sending without diagnostics');
    return null;
  } catch (error) {
    _debugLog('the provider threw ($error); sending without diagnostics');
    return null;
  }
  return validChatDiagnostics(raw);
}

/// Validates [raw] against the server's diagnostics rules and returns a
/// plain JSON copy of it, or null when it is null, empty, or invalid.
///
/// Values must be JSON: `null`, `bool`, finite `num`, `String` (at most
/// [chatDiagnosticsStringMax] characters), `List` (at most
/// [chatDiagnosticsArrayMax] items) or `Map` with `String` keys. Nesting is
/// at most [chatDiagnosticsMaxDepth] levels counting the top-level object,
/// and the compact JSON is at most [chatDiagnosticsMaxBytes] UTF-8 bytes.
/// Anything else drops the whole snapshot — never part of it — so the team
/// never sees a silently edited copy.
Map<String, Object?>? validChatDiagnostics(Map<String, Object?>? raw) {
  if (raw == null || raw.isEmpty) return null;
  final problem = _check(raw, 1);
  if (problem != null) {
    _debugLog('dropped: $problem');
    return null;
  }
  final String json;
  try {
    json = jsonEncode(raw);
  } catch (error) {
    _debugLog('dropped: not encodable as JSON ($error)');
    return null;
  }
  final bytes = utf8.encode(json).length;
  if (bytes > chatDiagnosticsMaxBytes) {
    _debugLog('dropped: $bytes bytes of JSON, over the '
        '$chatDiagnosticsMaxBytes-byte limit');
    return null;
  }
  // A detached copy: later changes to the host's map can't alter what was
  // validated.
  return (jsonDecode(json) as Map).cast<String, Object?>();
}

/// The first rule [value] (at nesting [depth]) breaks, or null.
String? _check(Object? value, int depth) {
  if (value == null || value is bool) return null;
  if (value is String) {
    return value.length <= chatDiagnosticsStringMax
        ? null
        : 'a string value is longer than $chatDiagnosticsStringMax '
            'characters';
  }
  if (value is num) {
    return value.isFinite ? null : 'a number is not finite';
  }
  if (value is Map || value is List) {
    if (depth > chatDiagnosticsMaxDepth) {
      return 'nested deeper than $chatDiagnosticsMaxDepth levels';
    }
    if (value is List) {
      if (value.length > chatDiagnosticsArrayMax) {
        return 'an array has more than $chatDiagnosticsArrayMax items';
      }
      for (final item in value) {
        final problem = _check(item, depth + 1);
        if (problem != null) return problem;
      }
      return null;
    }
    for (final entry in (value as Map).entries) {
      if (entry.key is! String) return 'a map key is not a String';
      final problem = _check(entry.value, depth + 1);
      if (problem != null) return problem;
    }
    return null;
  }
  return 'a value of type ${value.runtimeType} is not JSON';
}

void _debugLog(String message) {
  if (kDebugMode) debugPrint('Featurely chat diagnostics: $message');
}
