import 'dart:ui';

import 'package:flutter/foundation.dart' show kDebugMode;

import 'theme.dart';

/// Host callback invoked when an SDK operation fails after its retries.
///
/// [operation] names the API call (e.g. `listFeedback`, `submitFeedback`);
/// [error] is the thrown `FeaturelyApiException` or
/// `FeaturelyNetworkException`. Errors are also handled internally (the UI
/// shows its own localized states) — this hook exists purely so hosts can
/// log or report them. Exception text never contains the API key.
typedef FeaturelyErrorListener = void Function(
  String operation,
  Object error,
);

/// The environment this configuration reports to.
///
/// The single project API key identifies the project only; the SDK declares
/// the environment on every request (`X-Featurely-Environment`). By default
/// it is derived from the build type — debug builds report to Sandbox,
/// release builds to Live — and can be overridden at `init`. It is never a
/// user-facing runtime toggle.
enum FeaturelyEnvironment {
  /// Production data. The default for release builds.
  live,

  /// QA data. The default for debug builds; the sheet renders the amber
  /// SANDBOX strip.
  sandbox,
}

/// Resolved, immutable configuration produced by `Featurely.init`.
class FeaturelyOptions {
  /// Validates and normalizes the raw `init` arguments.
  FeaturelyOptions({
    required String baseUrl,
    required this.apiKey,
    FeaturelyEnvironment? environment,
    this.userId,
    this.plan,
    this.theme,
    this.locale,
    this.onError,
  })  : baseUrl = _normalizeBaseUrl(baseUrl),
        environment = environment ??
            (kDebugMode
                ? FeaturelyEnvironment.sandbox
                : FeaturelyEnvironment.live) {
    assert(
      apiKey.startsWith('fk_'),
      'Featurely API keys start with fk_. Copy the project key from '
      'Project Settings in the dashboard.',
    );
    assert(() {
      final uri = Uri.parse(this.baseUrl);
      final host = uri.host;
      final isLocal = host == 'localhost' ||
          host == '127.0.0.1' ||
          host == '10.0.2.2' ||
          host.endsWith('.local');
      return uri.scheme == 'https' || isLocal;
    }(), 'Featurely baseUrl must be HTTPS (plain HTTP is only acceptable for '
        'localhost development instances).');
  }

  /// Instance origin, e.g. `https://feedback.example.com` (no `/api/v1`).
  final String baseUrl;

  /// The project's single API key (`fk_…`).
  final String apiKey;

  /// The environment every request declares. Defaults to the build type:
  /// debug builds → [FeaturelyEnvironment.sandbox], release builds →
  /// [FeaturelyEnvironment.live].
  final FeaturelyEnvironment environment;

  /// External user id passed at init, if any.
  final String? userId;

  /// The host app's plan name for this user, sent with submissions.
  final String? plan;

  /// Theming knobs, resolved against the host theme at present time.
  final FeaturelyTheme? theme;

  /// Locale override; when null the device locale is used.
  final Locale? locale;

  /// Optional host error listener for logging/reporting.
  final FeaturelyErrorListener? onError;

  static String _normalizeBaseUrl(String url) {
    var normalized = url.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
