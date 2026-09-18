import 'dart:async';

import 'api/api_client.dart';
import 'api/models.dart';
import 'chat_actions.dart';
import 'chat_diagnostics.dart';
import 'identity/identity_store.dart';
import 'metadata.dart';
import 'options.dart';

/// The per-configuration runtime the sheet operates on: API client,
/// identity, session-long config cache, mutable plan, chat metadata, and
/// the chat assistant hooks (diagnostics provider, actions, action handler).
///
/// Internal — hosts only ever touch the `Featurely` facade. Kept as an
/// injectable object so widget tests can supply fakes.
class FeaturelyCore {
  /// Creates a core for [options].
  FeaturelyCore({
    required this.options,
    required this.identity,
    required this.api,
    required this.metadata,
    String? plan,
    this.chatMetadata,
    this.chatDiagnosticsProvider,
    this.chatActions = const [],
    this.chatActionHandler,
    Set<String>? usedChatActions,
  })  : plan = plan ?? options.plan,
        usedChatActions = usedChatActions ?? <String>{};

  /// Resolved init options.
  final FeaturelyOptions options;

  /// Device-ID and linked-user persistence.
  final IdentityStore identity;

  /// The API client bound to [options].
  final FeaturelyApiClient api;

  /// Lazy submission-metadata capturer.
  final DeviceMetadata metadata;

  /// The host app's plan label, mutable via `Featurely.setPlan`.
  String? plan;

  /// App-wide chat metadata (an unmodifiable copy), mutable via
  /// `Featurely.setChatMetadata`.
  Map<String, String>? chatMetadata;

  /// The host's diagnostics provider, mutable via
  /// `Featurely.setChatDiagnosticsProvider`.
  ChatDiagnosticsProvider? chatDiagnosticsProvider;

  /// The registered assistant actions (cleaned, unmodifiable), mutable via
  /// `Featurely.registerChatActions`.
  List<FeaturelyChatAction> chatActions;

  /// The host's action handler, mutable via `Featurely.setChatActionHandler`.
  FeaturelyChatActionResult Function(String id)? chatActionHandler;

  /// Assistant action buttons tapped this app session, as
  /// [chatActionKey]s. In memory only.
  final Set<String> usedChatActions;

  /// The action ids a chat send advertises as `availableActions`: the
  /// registered ones, but only while a handler can act on them.
  List<String> get availableChatActionIds => chatActionHandler == null
      ? const []
      : [for (final action in chatActions) action.id];

  /// The [usedChatActions] key of action [actionId] on message [messageId].
  static String chatActionKey(String messageId, String actionId) =>
      '$messageId/$actionId';

  /// Session-cached `GET /config` response.
  SdkConfig? cachedConfig;

  Future<void> _identityChain = Future.value();

  /// Serializes identity mutations (init link, login, logout) so rotations
  /// and links never interleave.
  Future<T> enqueueIdentityOp<T>(Future<T> Function() op) {
    final result = _identityChain.then((_) => op());
    _identityChain = result.then((_) {}, onError: (_) {});
    return result;
  }

  /// Whether this configuration talks to the Sandbox environment.
  bool get isSandbox => options.environment == FeaturelyEnvironment.sandbox;

  /// Returns the cached config immediately when present (refreshing it in
  /// the background), otherwise fetches it. Returns defaults when the fetch
  /// fails — the sheet still opens.
  Future<SdkConfig> config() async {
    final cached = cachedConfig;
    if (cached != null) {
      unawaited(_refreshConfig());
      return cached;
    }
    return _refreshConfig() //
        .then((config) => config ?? const SdkConfig.defaults());
  }

  Future<SdkConfig?> _refreshConfig() async {
    try {
      return cachedConfig = await api.getConfig();
    } catch (_) {
      return null; // Retried on next open.
    }
  }

  /// Marks commenting disabled after an authoritative `403
  /// comments_disabled` (the cached config was stale).
  void markCommentingDisabled() {
    final cached = cachedConfig;
    if (cached == null || !cached.commentingEnabled) return;
    cachedConfig = SdkConfig(
      projectName: cached.projectName,
      commentingEnabled: false,
      titleMax: cached.titleMax,
      descriptionMax: cached.descriptionMax,
      commentMax: cached.commentMax,
      attachmentMaxBytes: cached.attachmentMaxBytes,
      chatEnabled: cached.chatEnabled,
      assistantEnabled: cached.assistantEnabled,
    );
  }

  /// Links [userId], enforcing the account-switch rotation: if a different
  /// user is currently linked locally, performs the full logout rotation
  /// first, then links on the fresh device ID. Failures are recorded and
  /// silently retried on the next launch/link.
  Future<void> link(String userId) => enqueueIdentityOp(() async {
        final current = await identity.linkedUserId();
        final pending = await identity.linkPending();
        if (current == userId && !pending) return; // Idempotent no-op.
        if (current != null && current != userId) {
          await _logoutLocked();
        }
        await identity.setLinkedUser(userId, pending: true);
        try {
          await api.identify(userId);
          await identity.markLinkSynced();
        } catch (_) {
          // Fire-and-forget: retried on next launch/link.
        }
      });

  /// Retries a previously-failed link, if one is recorded.
  Future<void> retryPendingLink() => enqueueIdentityOp(() async {
        final current = await identity.linkedUserId();
        if (current == null || !await identity.linkPending()) return;
        try {
          await api.identify(current);
          await identity.markLinkSynced();
        } catch (_) {}
      });

  /// The contract's logout sequence: best-effort `DELETE /identify`, then
  /// generate and persist a new device ID. Rotates even when anonymous.
  Future<void> logout() => enqueueIdentityOp(_logoutLocked);

  Future<void> _logoutLocked() async {
    try {
      await api.unidentify();
    } catch (_) {
      // Best-effort by contract; the rotation below completes the logout.
    }
    await identity.rotate();
  }

  /// Releases resources.
  void dispose() => api.dispose();
}
