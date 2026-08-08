import 'package:flutter/foundation.dart';

import '../../api/api_client.dart';
import '../../api/api_exception.dart';
import '../../api/models.dart';

/// Transient notices the detail screen can surface.
enum DetailNotice {
  /// No notice.
  none,

  /// `403 comments_disabled` — the cached config was stale.
  commentsDisabled,

  /// A comment failed to send; the draft was restored to the composer.
  commentFailed,

  /// `429` — try again in a moment.
  rateLimited,
}

/// Controller for the detail screen: item, comments, optimistic voting, and
/// the comment composer. Created per navigation.
class FeedbackDetailController extends ChangeNotifier {
  /// Creates the controller seeded with the list row's [item].
  FeedbackDetailController({
    required this.api,
    required FeedbackItem item,
    required bool commentingEnabled,
    this.onVoteChanged,
    this.onItemGone,
  })  : _item = item,
        _commentingEnabled = commentingEnabled;

  /// The API client.
  final FeaturelyApiClient api;

  /// Notifies the list of reconciled vote state.
  final void Function(String id, int votes, {required bool viewerHasVoted})?
      onVoteChanged;

  /// Notifies the list that the item is gone (404) so it can be removed.
  final void Function(String id)? onItemGone;

  FeedbackItem _item;
  List<FeedbackComment> _comments = [];
  bool _loaded = false;
  bool _gone = false;
  bool _commentingEnabled;
  bool _sendingComment = false;
  String _restoredDraft = '';
  DetailNotice _notice = DetailNotice.none;
  bool _disposed = false;

  /// The item (seeded from the list, refreshed from `GET /feedback/:id`).
  FeedbackItem get item => _item;

  /// Public comments, chronological, plus any optimistically-pending one.
  List<FeedbackComment> get comments => List.unmodifiable(_comments);

  /// Whether the full detail response has arrived.
  bool get loaded => _loaded;

  /// True after a 404 — the screen pops back to the list.
  bool get gone => _gone;

  /// Whether the composer renders (cached config, corrected by 403s).
  bool get commentingEnabled => _commentingEnabled;

  /// Whether a comment is being sent.
  bool get sendingComment => _sendingComment;

  /// A failed comment's text, for the composer to restore. Cleared on read.
  String takeRestoredDraft() {
    final draft = _restoredDraft;
    _restoredDraft = '';
    return draft;
  }

  /// The active transient notice.
  DetailNotice get notice => _notice;

  /// Loads the detail (item + comments). A 404 marks the item [gone].
  Future<void> load() async {
    try {
      final detail = await api.getFeedback(_item.id);
      if (_disposed) return;
      _item = detail.item;
      _comments = List.of(detail.comments);
      _loaded = true;
      _notify();
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      if (error.code == FeaturelyErrorCode.notFound) _markGone();
    } catch (_) {
      // Keep rendering the seeded list row; comments stay empty.
    }
  }

  /// Optimistic vote toggle, mirroring the list behavior.
  Future<void> toggleVote() async {
    final original = _item;
    final voting = !original.viewerHasVoted;
    _item = original.copyWith(
      viewerHasVoted: voting,
      votes: original.votes + (voting ? 1 : -1),
    );
    _notify();
    try {
      final result =
          voting ? await api.vote(original.id) : await api.unvote(original.id);
      if (_disposed) return;
      _item = _item.copyWith(
        votes: result.votes,
        viewerHasVoted: result.viewerHasVoted,
      );
      onVoteChanged?.call(
        original.id,
        result.votes,
        viewerHasVoted: result.viewerHasVoted,
      );
      _notify();
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      if (error.code == FeaturelyErrorCode.notFound) {
        _markGone();
      } else {
        _item = original;
        if (error.code == FeaturelyErrorCode.rateLimited) {
          _notice = DetailNotice.rateLimited;
        }
        _notify();
      }
    } catch (_) {
      if (_disposed) return;
      _item = original;
      _notify();
    }
  }

  /// Sends a comment: appends it optimistically-pending, replaces it with
  /// the server's comment on 201, and handles the contract's error cases
  /// (403 hides the composer — config was stale; 404 pops; failures restore
  /// the draft).
  Future<void> addComment(String body) async {
    final trimmed = body.trim();
    if (trimmed.isEmpty || _sendingComment) return;
    final pending = FeedbackComment(
      id: '',
      author: CommentAuthor.anonymous,
      body: trimmed,
      createdAt: DateTime.now().toUtc(),
      pending: true,
    );
    _comments = [..._comments, pending];
    _sendingComment = true;
    _notice = DetailNotice.none;
    _notify();
    try {
      final comment = await api.addComment(_item.id, trimmed);
      if (_disposed) return;
      _comments = [..._comments]..removeLast();
      _comments.add(comment);
      _item = _item.copyWith(commentCount: _item.commentCount + 1);
      _notify();
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      _comments = [..._comments]..removeLast();
      switch (error.code) {
        case FeaturelyErrorCode.notFound:
          _markGone();
        case FeaturelyErrorCode.commentsDisabled:
          _commentingEnabled = false;
          _notice = DetailNotice.commentsDisabled;
        case FeaturelyErrorCode.rateLimited:
          _restoredDraft = trimmed;
          _notice = DetailNotice.rateLimited;
        default:
          _restoredDraft = trimmed;
          _notice = DetailNotice.commentFailed;
      }
      _notify();
    } catch (_) {
      if (_disposed) return;
      _comments = [..._comments]..removeLast();
      _restoredDraft = trimmed;
      _notice = DetailNotice.commentFailed;
      _notify();
    } finally {
      if (!_disposed) {
        _sendingComment = false;
        _notify();
      }
    }
  }

  void _markGone() {
    _gone = true;
    onItemGone?.call(_item.id);
    _notify();
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    super.dispose();
  }
}
