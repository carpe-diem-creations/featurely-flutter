import 'package:flutter/foundation.dart';

import '../../api/api_client.dart';
import '../../api/api_exception.dart';
import '../../api/models.dart';

/// State of the root list screen.
enum ListPhase {
  /// First page in flight — skeleton rows.
  loading,

  /// First page failed — error copy + Retry.
  error,

  /// Loaded with zero items — empty copy + CTA.
  empty,

  /// Loaded with items.
  loaded,
}

/// Controller for the feedback list: cursor pagination, sort/filter, and
/// optimistic vote toggling. Created per sheet presentation.
class FeedbackListController extends ChangeNotifier {
  /// Creates the controller.
  FeedbackListController({required this.api});

  /// The API client.
  final FeaturelyApiClient api;

  final List<FeedbackItem> _items = [];
  final Set<String> _ids = {};
  String? _nextCursor;
  bool _reachedEnd = false;
  bool _loadingFirst = false;
  bool _loadingMore = false;
  bool _failed = false;
  bool _loadMoreFailed = false;
  bool _disposed = false;
  int _generation = 0;

  FeedbackSort _sort = FeedbackSort.votes;
  FeedbackStatus? _statusFilter;

  /// Current sort; held constant across pages.
  FeedbackSort get sort => _sort;

  /// Current status filter (null = all visible statuses).
  FeedbackStatus? get statusFilter => _statusFilter;

  /// Whether sort/filter differ from the defaults.
  bool get hasActiveFilter =>
      _sort != FeedbackSort.votes || _statusFilter != null;

  /// The loaded items (deduped by id).
  List<FeedbackItem> get items => List.unmodifiable(_items);

  /// Whether a next page exists.
  bool get canLoadMore => !_reachedEnd && _nextCursor != null;

  /// Whether a next-page request is in flight.
  bool get loadingMore => _loadingMore;

  /// Whether the last next-page request failed — the list renders a retry
  /// footer instead of silently waiting for another scroll.
  bool get loadMoreFailed => _loadMoreFailed;

  /// The list phase driving which state widget renders.
  ListPhase get phase {
    if (_loadingFirst && _items.isEmpty) return ListPhase.loading;
    if (_failed && _items.isEmpty) return ListPhase.error;
    if (_items.isEmpty) return ListPhase.empty;
    return ListPhase.loaded;
  }

  /// Loads the first page (no cursor). Also the pull-to-refresh and Retry
  /// entry point.
  Future<void> loadFirst() async {
    final generation = ++_generation;
    _loadingFirst = true;
    _failed = false;
    _notify();
    try {
      final page = await api.listFeedback(sort: _sort, status: _statusFilter);
      if (_disposed || generation != _generation) return;
      _replaceWith(page);
    } catch (_) {
      if (_disposed || generation != _generation) return;
      _failed = true;
      if (_items.isEmpty) {
        _nextCursor = null;
        _reachedEnd = false;
      }
    } finally {
      if (!_disposed && generation == _generation) {
        _loadingFirst = false;
        _notify();
      }
    }
  }

  /// Appends the next page using the cursor verbatim. `invalid_cursor`
  /// (e.g. a sort-change race) restarts from no cursor.
  Future<void> loadMore() async {
    final cursor = _nextCursor;
    if (cursor == null || _reachedEnd || _loadingMore || _loadingFirst) return;
    final generation = _generation;
    _loadingMore = true;
    _loadMoreFailed = false;
    _notify();
    try {
      final page = await api.listFeedback(
        sort: _sort,
        status: _statusFilter,
        cursor: cursor,
      );
      if (_disposed || generation != _generation) return;
      _append(page);
    } on FeaturelyApiException catch (error) {
      if (_disposed || generation != _generation) return;
      if (error.code == FeaturelyErrorCode.invalidCursor) {
        _loadingMore = false;
        await loadFirst();
        return;
      }
      _loadMoreFailed = true;
    } catch (_) {
      // Transient: keep the cursor; the footer offers Retry (and any
      // further scroll retries too).
      if (_disposed || generation != _generation) return;
      _loadMoreFailed = true;
    } finally {
      if (!_disposed && generation == _generation) {
        _loadingMore = false;
        _notify();
      }
    }
  }

  /// Applies a new sort/filter, restarting from no cursor. When the filter
  /// sheet already fetched a preview [preload] page for its live count, it
  /// is used as the first page (saving a duplicate request).
  Future<void> applyFilter(
    FeedbackSort sort,
    FeedbackStatus? status, {
    Page<FeedbackItem>? preload,
  }) async {
    final changed = sort != _sort || status != _statusFilter;
    _sort = sort;
    _statusFilter = status;
    if (preload != null) {
      _generation++;
      _loadingFirst = false;
      _failed = false;
      _replaceWith(preload);
      _notify();
      return;
    }
    if (changed || _items.isEmpty) await loadFirst();
  }

  /// Optimistic, toggleable vote: flips the UI instantly, reconciles counts
  /// from the server response, reverts on failure, and removes the item on
  /// 404 (it was deleted or declined).
  Future<void> toggleVote(FeedbackItem item) async {
    final index = _items.indexWhere((candidate) => candidate.id == item.id);
    if (index < 0) return;
    final original = _items[index];
    final voting = !original.viewerHasVoted;
    _items[index] = original.copyWith(
      viewerHasVoted: voting,
      votes: original.votes + (voting ? 1 : -1),
    );
    _notify();
    try {
      final result =
          voting ? await api.vote(item.id) : await api.unvote(item.id);
      if (_disposed) return;
      _reconcile(item.id, result);
    } on FeaturelyApiException catch (error) {
      if (_disposed) return;
      if (error.code == FeaturelyErrorCode.notFound) {
        removeItem(item.id);
      } else {
        _revert(item.id, original);
      }
    } catch (_) {
      if (_disposed) return;
      _revert(item.id, original);
    }
  }

  /// Reconciles an item's vote state from a server response (also called by
  /// the detail screen so the two stay in sync).
  void _reconcile(String id, VoteResult result) {
    final index = _items.indexWhere((candidate) => candidate.id == id);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(
      votes: result.votes,
      viewerHasVoted: result.viewerHasVoted,
    );
    _notify();
  }

  /// Applies externally-observed vote state (from the detail screen).
  void syncVote(String id, int votes, {required bool viewerHasVoted}) =>
      _reconcile(id, VoteResult(votes: votes, viewerHasVoted: viewerHasVoted));

  void _revert(String id, FeedbackItem original) {
    final index = _items.indexWhere((candidate) => candidate.id == id);
    if (index < 0) return;
    _items[index] = original;
    _notify();
  }

  /// Removes an item that the server reported gone (404).
  void removeItem(String id) {
    _items.removeWhere((candidate) => candidate.id == id);
    _ids.remove(id);
    _notify();
  }

  void _replaceWith(Page<FeedbackItem> page) {
    _items..clear()..addAll(page.items);
    _ids
      ..clear()
      ..addAll(page.items.map((item) => item.id));
    _nextCursor = page.nextCursor;
    _reachedEnd = page.nextCursor == null;
    _failed = false;
    _loadMoreFailed = false;
  }

  void _append(Page<FeedbackItem> page) {
    // `votes`-sort pagination may repeat items (contract-accepted); de-dupe
    // appended pages by id.
    for (final item in page.items) {
      if (_ids.add(item.id)) _items.add(item);
    }
    _nextCursor = page.nextCursor;
    _reachedEnd = page.nextCursor == null;
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
