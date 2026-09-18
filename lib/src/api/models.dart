/// Data models for the frozen v1 contract.
///
/// All decoding is lenient: unknown JSON fields are ignored everywhere, and
/// unknown enum values collapse to safe defaults, so an SDK compiled against
/// this contract keeps working on every later server version.
library;

/// Feedback type. The end-user UI says "Feature" / "Issue"; the wire value
/// for an issue is `bug`.
enum FeedbackType {
  /// A feature request.
  feature('feature'),

  /// An issue report (wire value `bug`; rendered as "Issue", never "Bug").
  bug('bug');

  const FeedbackType(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode; unknown values default to [feature].
  static FeedbackType decode(Object? value) => values.firstWhere(
        (type) => type.wire == value,
        orElse: () => feature,
      );
}

/// The four end-user-visible statuses. `declined` does not exist through
/// this API and is deliberately not modeled.
enum FeedbackStatus {
  /// Newly submitted.
  open('open'),

  /// Committed, not started.
  planned('planned'),

  /// Actively being built.
  inProgress('in_progress'),

  /// Shipped.
  done('done');

  const FeedbackStatus(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode; unknown values default to [open] (the contract
  /// guarantees only these four are ever visible).
  static FeedbackStatus decode(Object? value) => values.firstWhere(
        (status) => status.wire == value,
        orElse: () => open,
      );
}

/// List sort orders.
enum FeedbackSort {
  /// Most voted first (the default).
  votes('votes'),

  /// Newest first.
  newest('newest'),

  /// Oldest first.
  oldest('oldest');

  const FeedbackSort(this.wire);

  /// The wire value.
  final String wire;
}

/// The public item shape — exactly the contract's ten fields.
class FeedbackItem {
  /// Creates an item.
  const FeedbackItem({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.status,
    required this.votes,
    required this.viewerHasVoted,
    required this.commentCount,
    required this.hasAttachment,
    required this.createdAt,
  });

  /// Lenient decode: unknown fields ignored, defensive defaults.
  factory FeedbackItem.fromJson(Map<String, dynamic> json) => FeedbackItem(
        id: json['id'] as String? ?? '',
        title: json['title'] as String? ?? '',
        description: json['description'] as String? ?? '',
        type: FeedbackType.decode(json['type']),
        status: FeedbackStatus.decode(json['status']),
        votes: (json['votes'] as num?)?.toInt() ?? 0,
        viewerHasVoted: json['viewerHasVoted'] as bool? ?? false,
        commentCount: (json['commentCount'] as num?)?.toInt() ?? 0,
        hasAttachment: json['hasAttachment'] as bool? ?? false,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );

  /// Server-generated id.
  final String id;

  /// Title (1–60 characters).
  final String title;

  /// Description (1–10 000 characters).
  final String description;

  /// Feature or issue.
  final FeedbackType type;

  /// Visible status.
  final FeedbackStatus status;

  /// Deduped vote count per identity.
  final int votes;

  /// Whether any device sharing the caller's identity has voted.
  final bool viewerHasVoted;

  /// Public comment count (internal notes are counted nowhere).
  final int commentCount;

  /// Whether a screenshot can be fetched from the attachment endpoint.
  final bool hasAttachment;

  /// Creation time (UTC).
  final DateTime createdAt;

  /// Copy with updated vote state.
  FeedbackItem copyWith({int? votes, bool? viewerHasVoted, int? commentCount}) {
    return FeedbackItem(
      id: id,
      title: title,
      description: description,
      type: type,
      status: status,
      votes: votes ?? this.votes,
      viewerHasVoted: viewerHasVoted ?? this.viewerHasVoted,
      commentCount: commentCount ?? this.commentCount,
      hasAttachment: hasAttachment,
      createdAt: createdAt,
    );
  }
}

/// A public comment author kind — deliberately no names, no emails.
enum CommentAuthor {
  /// Any end-user comment (including the caller's own).
  anonymous('anonymous'),

  /// A reply from the project's team.
  team('team');

  const CommentAuthor(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode; unknown kinds default to [anonymous].
  static CommentAuthor decode(Object? value) => values.firstWhere(
        (author) => author.wire == value,
        orElse: () => anonymous,
      );
}

/// A public comment.
class FeedbackComment {
  /// Creates a comment.
  const FeedbackComment({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
    this.pending = false,
  });

  /// Lenient decode.
  factory FeedbackComment.fromJson(Map<String, dynamic> json) =>
      FeedbackComment(
        id: json['id'] as String? ?? '',
        author: CommentAuthor.decode(json['author']),
        body: json['body'] as String? ?? '',
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
            DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      );

  /// Server-generated id (empty while [pending]).
  final String id;

  /// Author kind.
  final CommentAuthor author;

  /// Comment body.
  final String body;

  /// Creation time.
  final DateTime createdAt;

  /// True for an optimistically-appended comment not yet confirmed.
  final bool pending;
}

/// An item detail: the public item shape plus its chronological comments.
class FeedbackDetail {
  /// Creates a detail.
  const FeedbackDetail({required this.item, required this.comments});

  /// Lenient decode.
  factory FeedbackDetail.fromJson(Map<String, dynamic> json) => FeedbackDetail(
        item: FeedbackItem.fromJson(json),
        comments: ((json['comments'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(FeedbackComment.fromJson)
            .toList(),
      );

  /// The item.
  final FeedbackItem item;

  /// Public comments, chronological.
  final List<FeedbackComment> comments;
}

/// One page of a cursor-paginated list. [nextCursor] is null exactly on the
/// last page — that, not a short page, is the end-of-list signal.
class Page<T> {
  /// Creates a page.
  const Page({required this.items, required this.nextCursor});

  /// The page's items.
  final List<T> items;

  /// Opaque cursor for the next page, verbatim, or null at the end.
  final String? nextCursor;
}

/// The vote/unvote response: the state after the action, used to reconcile
/// the optimistic UI.
class VoteResult {
  /// Creates a result.
  const VoteResult({required this.votes, required this.viewerHasVoted});

  /// Lenient decode.
  factory VoteResult.fromJson(Map<String, dynamic> json) => VoteResult(
        votes: (json['votes'] as num?)?.toInt() ?? 0,
        viewerHasVoted: json['viewerHasVoted'] as bool? ?? false,
      );

  /// Deduped count after the action.
  final int votes;

  /// Whether the caller's identity has voted after the action.
  final bool viewerHasVoted;
}

/// Per-project configuration from `GET /config`, with the contract's
/// defaults used when the fetch fails.
class SdkConfig {
  /// Creates a config.
  const SdkConfig({
    required this.projectName,
    required this.commentingEnabled,
    required this.titleMax,
    required this.descriptionMax,
    required this.commentMax,
    required this.attachmentMaxBytes,
    this.chatEnabled = false,
    this.assistantEnabled = false,
  });

  /// Lenient decode with defaults.
  factory SdkConfig.fromJson(Map<String, dynamic> json) {
    final project = json['project'] as Map<String, dynamic>? ?? const {};
    final limits = json['limits'] as Map<String, dynamic>? ?? const {};
    return SdkConfig(
      projectName: project['name'] as String? ?? '',
      commentingEnabled: json['commentingEnabled'] as bool? ?? false,
      titleMax: (limits['titleMax'] as num?)?.toInt() ?? 60,
      descriptionMax: (limits['descriptionMax'] as num?)?.toInt() ?? 10000,
      commentMax: (limits['commentMax'] as num?)?.toInt() ?? 5000,
      attachmentMaxBytes:
          (limits['attachmentMaxBytes'] as num?)?.toInt() ?? 5242880,
      chatEnabled: json['chatEnabled'] as bool? ?? false,
      assistantEnabled: json['assistantEnabled'] as bool? ?? false,
    );
  }

  /// Defaults used when config could not be fetched: contract limits,
  /// commenting hidden until config confirms it, empty app name.
  const SdkConfig.defaults()
      : projectName = '',
        commentingEnabled = false,
        titleMax = 60,
        descriptionMax = 10000,
        commentMax = 5000,
        attachmentMaxBytes = 5242880,
        chatEnabled = false,
        assistantEnabled = false;

  /// `project.name` — supplies `{appName}` in strings.
  final String projectName;

  /// Whether the comment composer should render.
  final bool commentingEnabled;

  /// Title character limit.
  final int titleMax;

  /// Description character limit.
  final int descriptionMax;

  /// Comment character limit.
  final int commentMax;

  /// Authoritative screenshot size limit for client-side validation.
  final int attachmentMaxBytes;

  /// Whether the server supports In-App Chat. Absent (older servers) decodes
  /// to false, which hides every chat entry point.
  final bool chatEnabled;

  /// Whether the project's AI support assistant answers chat messages in
  /// this environment. Absent (older servers) decodes to false.
  /// Informational: the SDK always declares assistant support on sends and
  /// renders whatever the server returns.
  final bool assistantEnabled;
}

/// The maximum chat message length (trimmed, UTF-16 code units — the same
/// measure the server applies).
const int chatMessageMax = 4000;

/// Who wrote a chat message.
enum ChatAuthor {
  /// This device's end user.
  user('user'),

  /// The app's team.
  team('team');

  const ChatAuthor(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode; unknown values default to [team] so they render on the
  /// leading side rather than masquerading as the user's own words.
  static ChatAuthor decode(Object? value) => values.firstWhere(
        (author) => author.wire == value,
        orElse: () => team,
      );
}

/// Who wrote a chat message, distinguishing the AI assistant from people.
///
/// Assistant messages keep `author: 'team'` on the wire so older SDKs render
/// them as team replies; `authorKind` tells them apart.
enum ChatAuthorKind {
  /// This device's end user.
  endUser('end_user'),

  /// A person on the app's team.
  team('team'),

  /// The project's AI support assistant.
  assistant('assistant');

  const ChatAuthorKind(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode: an absent or unknown `authorKind` (servers without the
  /// assistant) falls back to [author] — a user message is [endUser],
  /// anything else [team].
  static ChatAuthorKind decode(Object? value, ChatAuthor author) {
    for (final kind in values) {
      if (kind.wire == value) return kind;
    }
    return author == ChatAuthor.user ? endUser : team;
  }
}

/// Conversation status.
enum ConversationStatus {
  /// Awaiting the team (or ongoing).
  open('open'),

  /// Resolved by the team; a new user message reopens it.
  closed('closed');

  const ConversationStatus(this.wire);

  /// The wire value.
  final String wire;

  /// Lenient decode; unknown values default to [open].
  static ConversationStatus decode(Object? value) => values.firstWhere(
        (status) => status.wire == value,
        orElse: () => open,
      );
}

/// A public chat message: `{id, author, body, createdAt, clientMessageId}`,
/// plus `authorKind` and, on assistant messages, `authorName` and `actions`.
/// Team messages never carry a name or email.
class ChatMessage {
  /// Creates a message.
  const ChatMessage({
    required this.id,
    required this.author,
    required this.body,
    required this.createdAt,
    this.clientMessageId,
    ChatAuthorKind? authorKind,
    this.authorName,
    this.actions = const [],
  }) : _authorKind = authorKind;

  /// Lenient decode. Messages from servers without the assistant (no
  /// `authorKind`) decode exactly as before.
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    final author = ChatAuthor.decode(json['author']);
    final kind = ChatAuthorKind.decode(json['authorKind'], author);
    final isAssistant = kind == ChatAuthorKind.assistant;
    final name = json['authorName'];
    return ChatMessage(
      id: json['id'] as String? ?? '',
      author: author,
      body: json['body'] as String? ?? '',
      createdAt: DateTime.tryParse(json['createdAt'] as String? ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      clientMessageId: json['clientMessageId'] as String?,
      authorKind: kind,
      authorName: isAssistant && name is String ? name : null,
      actions: isAssistant
          ? List.unmodifiable(
              ((json['actions'] as List<dynamic>?) ?? const [])
                  .whereType<String>(),
            )
          : const [],
    );
  }

  /// Server-generated id.
  final String id;

  /// Author side: the user or the team (assistant messages are `team`).
  final ChatAuthor author;

  /// Plain-text body.
  final String body;

  /// Creation time (UTC).
  final DateTime createdAt;

  /// The client-generated UUID; set only on this device's own messages.
  final String? clientMessageId;

  final ChatAuthorKind? _authorKind;

  /// Who wrote it, derived from [author] when the server didn't say.
  ChatAuthorKind get authorKind =>
      _authorKind ??
      (author == ChatAuthor.user ? ChatAuthorKind.endUser : ChatAuthorKind.team);

  /// Whether the project's AI assistant wrote this message.
  bool get isAssistant => authorKind == ChatAuthorKind.assistant;

  /// The assistant's display name (assistant messages only; may be null).
  final String? authorName;

  /// Action ids the assistant suggested (assistant messages only). The SDK
  /// shows only those the host app registered.
  final List<String> actions;
}

/// The device's single conversation (`GET /conversation`).
class ChatConversation {
  /// Creates a conversation.
  const ChatConversation({
    required this.id,
    required this.status,
    required this.contactEmail,
    required this.unreadCount,
    required this.lastMessageAt,
  });

  /// Lenient decode.
  factory ChatConversation.fromJson(Map<String, dynamic> json) =>
      ChatConversation(
        id: json['id'] as String? ?? '',
        status: ConversationStatus.decode(json['status']),
        contactEmail: json['contactEmail'] as String?,
        unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
        lastMessageAt: DateTime.tryParse(json['lastMessageAt'] as String? ?? ''),
      );

  /// Server-generated id.
  final String id;

  /// Open or closed.
  final ConversationStatus status;

  /// The address team replies are emailed to, if any.
  final String? contactEmail;

  /// Team messages newer than this device's last read marker.
  final int unreadCount;

  /// Time of the latest message, if any.
  final DateTime? lastMessageAt;
}

/// One page of chat messages (ascending) plus both opaque paging cursors.
class ChatMessagesPage {
  /// Creates a page.
  const ChatMessagesPage({
    required this.messages,
    required this.olderCursor,
    required this.newerCursor,
    this.assistantPending = false,
  });

  /// Lenient decode.
  factory ChatMessagesPage.fromJson(Map<String, dynamic> json) =>
      ChatMessagesPage(
        messages: ((json['messages'] as List<dynamic>?) ?? const [])
            .whereType<Map<String, dynamic>>()
            .map(ChatMessage.fromJson)
            .toList(),
        olderCursor: json['olderCursor'] as String?,
        newerCursor: json['newerCursor'] as String?,
        assistantPending: json['assistantPending'] as bool? ?? false,
      );

  /// Messages, oldest first.
  final List<ChatMessage> messages;

  /// Pass as `before` to fetch older messages; null when none exist.
  final String? olderCursor;

  /// Pass as `after` to poll; null only when the device has no messages.
  final String? newerCursor;

  /// Whether the AI assistant is working on a reply right now. Absent
  /// (servers without the assistant) decodes to false.
  final bool assistantPending;
}
