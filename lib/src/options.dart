import 'dart:ui';

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

/// The environment a Featurely API key addresses.
///
/// Derived from the key prefix — never a runtime toggle: `fk_test_…` keys read
/// and write only Sandbox data, `fk_live_…` keys only Live data.
enum FeaturelyEnvironment {
  /// Production data (`fk_live_…` keys, and unrecognized prefixes for
  /// forward compatibility).
  live,

  /// QA data (`fk_test_…` keys). The sheet renders the amber SANDBOX strip.
  sandbox,
}

/// Resolved, immutable configuration produced by `Featurely.init`.
class FeaturelyOptions {
  /// Validates and normalizes the raw `init` arguments.
  FeaturelyOptions({
    required String baseUrl,
    required this.apiKey,
    this.userId,
    this.plan,
    this.theme,
    this.locale,
    this.onError,
  }) : baseUrl = _normalizeBaseUrl(baseUrl) {
    assert(
      apiKey.startsWith('fk_live_') || apiKey.startsWith('fk_test_'),
      'Featurely API keys start with fk_live_ or fk_test_. An unrecognized '
      'prefix is treated as Live (forward-compatible), but is almost '
      'certainly a mistake.',
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

  /// The project API key (`fk_live_…` or `fk_test_…`).
  final String apiKey;

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

  /// Environment derived from the key prefix. Keys matching neither prefix
  /// are treated as Live (forward-compatible).
  FeaturelyEnvironment get environment => apiKey.startsWith('fk_test_')
      ? FeaturelyEnvironment.sandbox
      : FeaturelyEnvironment.live;

  static String _normalizeBaseUrl(String url) {
    var normalized = url.trim();
    while (normalized.endsWith('/')) {
      normalized = normalized.substring(0, normalized.length - 1);
    }
    return normalized;
  }
}
