import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import 'api/api_client.dart';
import 'core.dart';
import 'identity/identity_store.dart';
import 'metadata.dart';
import 'options.dart';
import 'theme.dart';
import 'ui/sheet.dart';

/// The Featurely SDK facade.
///
/// Call [init] once at startup, then [show] from any trigger. Optionally
/// wire [login]/[logout] to the host app's own auth so a user's votes
/// follow them across devices, [setPlan] when their plan changes, and
/// [setChatMetadata] to give your team context on chat messages.
class Featurely {
  Featurely._();

  static FeaturelyCore? _core;

  /// Test hook: injected HTTP client for the API layer.
  @visibleForTesting
  static http.Client? debugHttpClient;

  /// Test hook: injected metadata override.
  @visibleForTesting
  static Map<String, String>? debugMetadataOverride;

  /// Configures the SDK. Idempotent — safe (and recommended) to call on
  /// every launch; calling it again replaces the configuration.
  ///
  /// [baseUrl] is the instance origin (no `/api/v1` suffix). [apiKey] is the
  /// project's single key (`fk_…`), always available in Project Settings.
  ///
  /// [environment] declares which environment this app reports to. Leave it
  /// null for the automatic default — debug builds hit Sandbox (and render
  /// the SANDBOX strip), release builds hit Live — and set it explicitly
  /// only for special build flavors (e.g. a staging release build that
  /// should stay in Sandbox). It is never a user-facing runtime toggle.
  ///
  /// [userId] links the device to the host app's own account system (same
  /// semantics as [login]; last write wins). [plan] is attached to
  /// submissions (e.g. `'Pro Monthly'`). [theme] and [locale] override the
  /// host-derived look and language.
  ///
  /// [onError] is an optional observability hook: it receives every API
  /// operation that ultimately fails (after retries), so hosts can log or
  /// report SDK trouble — a rotated key, an unreachable instance — that the
  /// SDK otherwise handles silently with its own localized UI states.
  ///
  /// Never blocks the host app on network: the returned future completes
  /// after local setup; identity linking runs fire-and-forget.
  static Future<void> init({
    required String baseUrl,
    required String apiKey,
    FeaturelyEnvironment? environment,
    String? userId,
    String? plan,
    FeaturelyTheme? theme,
    Locale? locale,
    FeaturelyErrorListener? onError,
  }) async {
    final options = FeaturelyOptions(
      baseUrl: baseUrl,
      apiKey: apiKey,
      environment: environment,
      userId: userId,
      plan: plan,
      theme: theme,
      locale: locale,
      onError: onError,
    );
    final previous = _core;
    final sameBackend = previous != null &&
        previous.options.baseUrl == options.baseUrl &&
        previous.options.apiKey == options.apiKey &&
        previous.options.environment == options.environment;
    final identity = previous?.identity ?? IdentityStore();
    final core = FeaturelyCore(
      options: options,
      identity: identity,
      api: FeaturelyApiClient(
        baseUrl: options.baseUrl,
        apiKey: options.apiKey,
        environment: options.environment.name,
        deviceIdProvider: identity.deviceId,
        httpClient: debugHttpClient,
        onError: onError,
      ),
      metadata: DeviceMetadata(override: debugMetadataOverride),
      plan: plan,
      // Not an init option: survives re-configuration like the identity.
      chatMetadata: previous?.chatMetadata,
    );
    // The config cache is per app session; keep it when the backend didn't
    // change so later opens reuse it.
    if (sameBackend) core.cachedConfig = previous.cachedConfig;
    _core = core;
    if (previous != null && !sameBackend) previous.dispose();

    // Local-only setup; network work below is fire-and-forget.
    await identity.deviceId();
    if (userId != null) {
      unawaited(core.link(userId));
    } else {
      unawaited(core.retryPendingLink());
    }
  }

  /// Presents the full-height feedback sheet and completes when it is
  /// dismissed. Throws a [StateError] when called before [init].
  static Future<void> show(BuildContext context) {
    final core = _requireCore('show');
    return showFeaturelySheet(context, core);
  }

  /// Presents the In-App Chat as a standalone full-height sheet (the same
  /// theming, localization and SANDBOX strip as [show]) and completes when
  /// it is dismissed. Throws a [StateError] when called before [init].
  ///
  /// Chat is a private one-to-one thread between this device and your team;
  /// replies arrive by polling while the screen is open (and by email when
  /// the user left an address). The thread belongs to the device ID, so
  /// [logout] starts a fresh, empty chat. Requires a Featurely server that
  /// reports `chatEnabled` — against an older server the screen shows its
  /// failed-load state, so gate your own entry point on a server you know
  /// supports chat. The feedback sheet opened by [show] offers a
  /// "Message us" action automatically when the server supports it.
  ///
  /// [metadata] is context for the team about this presentation (e.g.
  /// `{'screen': 'Checkout', 'orderId': '1234'}`), attached to every message
  /// sent from it on top of the app-wide [setChatMetadata] map — on a key
  /// collision, [metadata] wins. It follows the same rules and limits as
  /// [setChatMetadata].
  ///
  /// [initialMessage] prefills the message composer when the chat opens
  /// (e.g. `'I have a question about order #1234'`), with the cursor at the
  /// end. It is never sent automatically — the user can edit or delete it
  /// first. It is trimmed, ignored when blank, capped to the 4 000-character
  /// message limit, and applied once per call: it doesn't reappear after
  /// the user sends or clears it.
  static Future<void> showChat(
    BuildContext context, {
    Map<String, String>? metadata,
    String? initialMessage,
  }) {
    final core = _requireCore('showChat');
    return showFeaturelySheet(
      context,
      core,
      root: FeaturelySheetRoot.chat,
      chatMetadata: metadata == null ? null : Map.unmodifiable(metadata),
      chatInitialMessage: initialMessage,
    );
  }

  /// The number of team chat messages this device hasn't read yet — for a
  /// badge on your own chat button.
  ///
  /// Never throws: returns `0` before [init], when the device has no
  /// conversation, when the server doesn't support chat (`chatEnabled`
  /// false or absent), and on any error. Each call makes a network request
  /// (config is cached per session), so call it on demand — e.g. on app
  /// resume — rather than in a tight loop.
  static Future<int> unreadMessageCount() async {
    final core = _core;
    if (core == null) return 0;
    try {
      final config = await core.config();
      if (!config.chatEnabled) return 0;
      final conversation = await core.api.getConversation();
      return conversation?.unreadCount ?? 0;
    } catch (_) {
      return 0;
    }
  }

  /// Whether this device has team chat messages it hasn't read — for a
  /// simple dot badge on your own chat button. Equivalent to
  /// `await unreadMessageCount() > 0`, with the same semantics: never
  /// throws, and returns `false` before [init], when the device has no
  /// conversation, when the server doesn't support chat, and on any error.
  /// Each call makes a network request, so call it on demand:
  ///
  /// ```dart
  /// Future<bool> _unread = Featurely.hasUnreadMessages();
  ///
  /// // In build():
  /// FutureBuilder<bool>(
  ///   future: _unread,
  ///   builder: (context, snapshot) => Badge(
  ///     isLabelVisible: snapshot.data ?? false,
  ///     child: IconButton(
  ///       icon: const Icon(Icons.chat_bubble_outline),
  ///       onPressed: () async {
  ///         await Featurely.showChat(context);
  ///         // Refresh once the chat is closed (and e.g. on app resume).
  ///         setState(() => _unread = Featurely.hasUnreadMessages());
  ///       },
  ///     ),
  ///   ),
  /// )
  /// ```
  static Future<bool> hasUnreadMessages() async =>
      (await unreadMessageCount()) > 0;

  /// Links the device to [userId] via `POST /identify`. Idempotent; calling
  /// with a new id while another user is linked performs the logout
  /// rotation first (the SDK enforces account switching). Link failures are
  /// silent and retried on the next launch/link.
  static Future<void> login(String userId) =>
      _requireCore('login').link(userId);

  /// Logs out: best-effort `DELETE /identify`, then rotates to a brand-new
  /// device ID so the next user of the device starts clean. Safe to call
  /// when anonymous.
  static Future<void> logout() => _requireCore('logout').logout();

  /// Updates the plan label sent with future submissions (e.g. after an
  /// upgrade mid-session).
  static void setPlan(String? plan) => _requireCore('setPlan').plan = plan;

  /// Sets app-wide context attached to every chat message sent from now on
  /// (e.g. `{'plan': 'pro', 'appVersion': '2.4.1'}`); `null` clears it.
  /// Messages already sent — including a failed one the user retries — keep
  /// the metadata they were composed with. Survives a later [init].
  ///
  /// The map is shown to your team next to the message in the dashboard
  /// Inbox and in the support alert email. It is never shown to the user
  /// and never returned by the API — but don't put secrets in it.
  ///
  /// Values are plain strings. Keys and values are trimmed; entries with a
  /// blank key or value, or a key longer than 64 characters, are dropped;
  /// values are truncated to 500 characters; at most 20 entries are sent
  /// (the first 20 by sorted key). Invalid input never throws. The map is
  /// copied, so later changes to it have no effect. Merged with the
  /// per-presentation `metadata` of [showChat] (which wins on collisions);
  /// the feedback sheet's "Message us" chat uses this map alone.
  static void setChatMetadata(Map<String, String>? metadata) =>
      _requireCore('setChatMetadata').chatMetadata =
          metadata == null ? null : Map.unmodifiable(metadata);

  static FeaturelyCore _requireCore(String method) {
    final core = _core;
    if (core == null) {
      throw StateError(
        'Featurely.init must be called before $method. Call Featurely.init('
        'baseUrl: …, apiKey: …) once at app startup.',
      );
    }
    return core;
  }

  /// Test hook: clears all static state.
  @visibleForTesting
  static void debugReset() {
    _core?.dispose();
    _core = null;
    debugHttpClient = null;
    debugMetadataOverride = null;
  }
}
