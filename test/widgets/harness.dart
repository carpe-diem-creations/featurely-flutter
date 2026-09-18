import 'package:featurely/src/api/api_client.dart';
import 'package:featurely/src/api/models.dart';
import 'package:featurely/src/core.dart';
import 'package:featurely/src/identity/identity_store.dart';
import 'package:featurely/src/l10n/locale_resolution.dart';
import 'package:featurely/src/metadata.dart';
import 'package:featurely/src/options.dart';
import 'package:featurely/src/theme.dart';
import 'package:featurely/src/ui/sheet.dart';
import 'package:flutter/material.dart' hide Page;
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// A fake API client with per-endpoint handler hooks.
class FakeApi extends FeaturelyApiClient {
  FakeApi()
      : super(
          baseUrl: 'https://feedback.example.com',
          apiKey: 'fk_fake',
          environment: 'sandbox',
          deviceIdProvider: () async => 'u_fake_device_1234567890',
          httpClient: MockClient(
            (request) async => http.Response('unexpected', 500),
          ),
        );

  SdkConfig config = const SdkConfig(
    projectName: 'Pocket Bartender',
    commentingEnabled: true,
    titleMax: 60,
    descriptionMax: 10000,
    commentMax: 5000,
    attachmentMaxBytes: 5242880,
  );

  Future<Page<FeedbackItem>> Function(
      FeedbackSort sort, FeedbackStatus? status, String? cursor, int? limit)?
      onList;
  Future<FeedbackDetail> Function(String id)? onGetFeedback;
  Future<VoteResult> Function(String id)? onVote;
  Future<VoteResult> Function(String id)? onUnvote;
  Future<FeedbackComment> Function(String id, String body)? onAddComment;
  Future<FeedbackItem> Function()? onSubmit;

  // In-App Chat. Defaults model a never-seen device.
  Future<ChatConversation?> Function()? onGetConversation;
  Future<ChatMessagesPage> Function(String? before, String? after)?
      onGetChatMessages;
  Future<ChatMessage> Function(String body, String clientMessageId)?
      onSendChatMessage;
  Future<void> Function(String? email)? onSetChatEmail;
  Future<void> Function()? onMarkChatRead;

  /// Every `getChatMessages` call as `(before, after)`.
  final List<(String?, String?)> chatMessageCalls = [];

  /// Every `sendChatMessage` call as `(body, clientMessageId)`.
  final List<(String, String)> sendCalls = [];

  /// The `resolvedLocale` of the most recent `sendChatMessage` call.
  String? lastChatResolvedLocale;

  /// The `metadata` of every `sendChatMessage` call, parallel to
  /// [sendCalls].
  final List<Map<String, String>?> sendMetadata = [];

  /// The `diagnostics` of every `sendChatMessage` call, parallel to
  /// [sendCalls].
  final List<Map<String, Object?>?> sendDiagnostics = [];

  /// The `availableActions` of every `sendChatMessage` call, parallel to
  /// [sendCalls].
  final List<List<String>?> sendActions = [];

  /// Every `setChatEmail` argument.
  final List<String?> emailCalls = [];

  /// Number of `markChatRead` calls.
  int readCalls = 0;

  /// The metadata map of the most recent [submitFeedback] call.
  Map<String, String>? lastSubmissionMetadata;

  @override
  Future<SdkConfig> getConfig() async => config;

  @override
  Future<Page<FeedbackItem>> listFeedback({
    FeedbackSort sort = FeedbackSort.votes,
    FeedbackStatus? status,
    String? cursor,
    int? limit,
  }) {
    final handler = onList;
    if (handler == null) {
      return Future.value(const Page(items: <FeedbackItem>[], nextCursor: null));
    }
    return handler(sort, status, cursor, limit);
  }

  @override
  Future<FeedbackDetail> getFeedback(String id) =>
      onGetFeedback!.call(id);

  @override
  Future<VoteResult> vote(String id) => onVote!.call(id);

  @override
  Future<VoteResult> unvote(String id) => onUnvote!.call(id);

  @override
  Future<FeedbackComment> addComment(String id, String body) =>
      onAddComment!.call(id, body);

  @override
  Future<ChatConversation?> getConversation() =>
      onGetConversation?.call() ?? Future.value();

  @override
  Future<ChatMessagesPage> getChatMessages({
    String? before,
    String? after,
    int? limit,
  }) {
    chatMessageCalls.add((before, after));
    return onGetChatMessages?.call(before, after) ??
        Future.value(ChatMessagesPage(
          messages: const [],
          olderCursor: null,
          newerCursor: after,
        ));
  }

  @override
  Future<ChatMessage> sendChatMessage({
    required String body,
    required String clientMessageId,
    String? deviceLocale,
    String? resolvedLocale,
    Map<String, String>? metadata,
    Map<String, Object?>? diagnostics,
    List<String>? availableActions,
  }) {
    sendCalls.add((body, clientMessageId));
    sendMetadata.add(metadata);
    sendDiagnostics.add(diagnostics);
    sendActions.add(availableActions);
    lastChatResolvedLocale = resolvedLocale;
    return onSendChatMessage?.call(body, clientMessageId) ??
        Future.value(makeChatMessage(
          id: 'srv-$clientMessageId',
          body: body,
          clientMessageId: clientMessageId,
        ));
  }

  @override
  Future<void> setChatEmail(String? email) {
    emailCalls.add(email);
    return onSetChatEmail?.call(email) ?? Future.value();
  }

  @override
  Future<void> markChatRead() {
    readCalls++;
    return onMarkChatRead?.call() ?? Future.value();
  }

  @override
  Future<FeedbackItem> submitFeedback({
    required String title,
    required String description,
    required FeedbackType type,
    String? email,
    Map<String, String> metadata = const {},
    screenshotBytes,
    String? screenshotContentType,
  }) {
    lastSubmissionMetadata = metadata;
    return onSubmit!.call();
  }
}

/// A feedback item fixture.
FeedbackItem makeItem({
  String id = 'item-1',
  String title = 'Offline mode for saved articles',
  int votes = 12,
  bool voted = false,
  FeedbackStatus status = FeedbackStatus.open,
  int comments = 3,
  bool hasAttachment = false,
}) =>
    FeedbackItem(
      id: id,
      title: title,
      description: 'A longer description of the request.',
      type: FeedbackType.feature,
      status: status,
      votes: votes,
      viewerHasVoted: voted,
      commentCount: comments,
      hasAttachment: hasAttachment,
      createdAt: DateTime.utc(2026, 7, 14, 8, 21),
    );

/// A chat message fixture.
ChatMessage makeChatMessage({
  required String id,
  String body = 'Hello',
  ChatAuthor author = ChatAuthor.user,
  String? clientMessageId,
  DateTime? createdAt,
}) =>
    ChatMessage(
      id: id,
      author: author,
      body: body,
      createdAt: createdAt ?? DateTime.utc(2026, 9, 1, 10),
      clientMessageId: clientMessageId,
    );

/// An AI assistant message fixture (wire `author: 'team'`).
ChatMessage makeAssistantMessage({
  required String id,
  String body = 'Try this:\n1. Open Settings.\n2. Tap "Pair".',
  String? authorName = 'Lyn',
  List<String> actions = const [],
  DateTime? createdAt,
}) =>
    ChatMessage(
      id: id,
      author: ChatAuthor.team,
      authorKind: ChatAuthorKind.assistant,
      authorName: authorName,
      actions: actions,
      body: body,
      createdAt: createdAt ?? DateTime.utc(2026, 9, 1, 10),
    );

/// A conversation fixture.
ChatConversation makeConversation({int unread = 0, String? email}) =>
    ChatConversation(
      id: 'conv-1',
      status: ConversationStatus.open,
      contactEmail: email,
      unreadCount: unread,
      lastMessageAt: DateTime.utc(2026, 9, 1, 10),
    );

/// Builds a [FeaturelyCore] over [api].
FeaturelyCore makeCore(
  FakeApi api, {
  FeaturelyEnvironment environment = FeaturelyEnvironment.sandbox,
  Locale? locale,
  bool seedConfig = true,
}) {
  final core = FeaturelyCore(
    options: FeaturelyOptions(
      baseUrl: 'https://feedback.example.com',
      apiKey: 'fk_fake',
      environment: environment,
      locale: locale,
    ),
    identity: IdentityStore(),
    api: api,
    metadata: DeviceMetadata(override: const {
      'appVersion': '1.0.0',
      'appBuild': '1',
      'osVersion': 'TestOS 1',
      'deviceModel': 'Test Device',
      'deviceLocale': 'en-US',
    }),
  );
  if (seedConfig) core.cachedConfig = api.config;
  return core;
}

/// Pumps the full sheet inside a host `MaterialApp`.
Future<void> pumpSheet(
  WidgetTester tester,
  FeaturelyCore core, {
  FeaturelyTheme? theme,
  Size surface = const Size(390, 844),
  FeaturelySheetRoot root = FeaturelySheetRoot.list,
  Map<String, String>? chatMetadata,
  String? chatInitialMessage,
}) async {
  await tester.binding.setSurfaceSize(surface);
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      home: Builder(
        builder: (context) => FeaturelySheet(
          core: core,
          theme: FeaturelyThemeData.resolve(context, theme),
          localeTag: resolveLocaleTag(core.options.locale?.toLanguageTag()),
          platform: TargetPlatform.android,
          root: root,
          chatMetadata: chatMetadata,
          chatInitialMessage: chatInitialMessage,
        ),
      ),
    ),
  );
  await tester.pump();
}
