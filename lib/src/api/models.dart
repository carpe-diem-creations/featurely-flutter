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
        attachmentMaxBytes = 5242880;

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
}
